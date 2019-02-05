import React, { Component } from 'react';
import { Badge, Card, CardBody, CardFooter, CardHeader, Col, Row, Collapse, Fade } from 'reactstrap';

class Article extends Component {
    constructor(props) {
        super(props);

        this.state = {
            id: '',
            title: '',
            remark: ''
        };
    }

    componentDidMount() {
        const id = this.props.match.params.id;
        const axios = require('axios');
        axios.get(`/articles/${id}.json`)
            .then((results) => {
                console.log(results);
                this.setState(results.data);
            })
            .catch((data) =>{
                console.log(data);
            })
    }

    render() {
      return (
        <div className="animated fadeIn">
            <Card>
                <CardHeader>
                    {this.state.title}
                </CardHeader>
                <CardBody>
                    <span dangerouslySetInnerHTML={{__html: this.state.remark}}></span>
                </CardBody>
            </Card>
        </div>
    );
  }
}

export default Article;
