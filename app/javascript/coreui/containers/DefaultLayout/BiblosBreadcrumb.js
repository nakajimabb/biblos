import React, {Component} from 'react';


class BiblosBreadcrumb extends Component {
    constructor(props) {
        super(props);
        this.state = {
            list: ['ホーム']
        }
    }

    render() {
        return (
            <div className="breadcrumb">
                {this.state.list.map((menu, idx) => {
                    return menu;
                    }).join(' / ')
                }
            </div>
        );
    }
}

export default BiblosBreadcrumb;
