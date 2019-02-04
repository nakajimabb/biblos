import './Articles.scss';

import React, { Component } from 'react';
import { Badge, Card, CardBody, CardFooter, CardHeader, Col, Row, Collapse, Fade } from 'reactstrap';
import { AppSwitch } from '@coreui/react'

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
        this.setState({articles: results.data});
    })
    .catch((data) =>{
        console.log(data);
    })
  }

  render() {
     const list = this.state.articles.map((article, index) => {
     return  (
         <Col xs="12" sm="4" md="3">
           <Card>
               <CardHeader className="article-title">
                   {article.title}
               </CardHeader>
               <CardBody className="article-headline">
                   {article.headline}
               </CardBody>
           </Card>
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

export default Articles;
