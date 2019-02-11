import './index.scss';

import React, { Component } from 'react';
import { Badge, Card, CardBody, CardFooter, CardHeader, Col, Row, Collapse, Fade } from 'reactstrap';
import { AppSwitch } from '@coreui/react'
import { BrowserRouter as Router, Route, Link } from 'react-router-dom'
import PropTypes from 'prop-types';


const Article = React.lazy(() => import('./show'));

class Articles extends Component {
  constructor(props) {
    super(props);

    this.toggle = this.toggle.bind(this);
    this.toggleFade = this.toggleFade.bind(this);
    this.state = {
      articles: []
    };
  }

  toggle() {
    this.setState({ collapse: !this.state.collapse });
  }

  toggleFade() {
    this.setState((prevState) => { return { fadeIn: !prevState }});
  }

  componentDidMount() {
    const axios = require('axios');
    axios.get('/articles.json')
    .then((results) => {
        console.log(results);
        this.setState({articles: results.data.articles});
        this.props.setBreadcrumb(results.data.breadcrumb);
    })
    .catch((data) =>{
        console.log(data);
    })
  }

  render() {
     const list = this.state.articles.map((article, index) => {
     return  (
         <Col xs="12" sm="4" md="3">
             <Link to={`/articles/${article.id}`} className="linked-card">
                <Card>
                    <CardHeader className="article-title">
                       {article.title}
                   </CardHeader>
                   <CardBody className="article-headline">
                       {article.headline}
                   </CardBody>
                </Card>
            </Link>
         </Col>
         );
     });

     return (
      <div className="animated fadeIn">
        <Row>
          {list}
        </Row>
      </div>
    );
  }
}

Articles.propTypes = {
    setSubmenu: PropTypes.func
};

export default Articles;
