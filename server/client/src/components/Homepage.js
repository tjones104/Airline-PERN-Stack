import React, {Component} from 'react';
import FindFlights from '../components/FindFlights';
import ListFlights from '../components/ListFlights';
import CustomerInfo from '../components/CustomerInfo';
import RefundPage from '../components/RefundPage';
import ListAllFlights from '../components/ListAllFlights';
import PickSeat from '../components/PickSeat';
import Payment from '../components/Payment';
import AirlinePortal from '../components/AirlinePortal';
import GeneratedNumber from '../components/GeneratedNumber';
import CheckTicket from '../components/CheckTicket';
import CheckBooking from '../components/CheckBooking';
import AboutPage from '../components/AboutPage';
import "react-bulma-components/dist/react-bulma-components.min.css";
import Nav from '../components/Nav';


class HomePage extends Component {
    constructor(props){
        super(props);
        this.navHandler = this.navHandler.bind(this);
    }

    state = {
        page: "AboutPage"
    }

    navHandler(tab) {
        this.setState({page: tab});
    }



    submitDestination = () => {
        setTimeout(function(){this.setState({ page: "ListFlights"})}.bind(this), 500);
    };

    submitFlight = () => {
        this.setState({ page: "CustomerInfo"});
    };

    submitRefund = () => {
        this.setState({ page: "RefundPage"});
    };
    
    submitCustomerInfo = () => {
        this.setState({ page: "Payment"});
    };
    
    submitPayment = () => {
        this.setState({ page: "PickSeat"});
    };

    submitSeat = () => {
        setTimeout(function(){this.setState({ page: "GeneratedNumber"})}.bind(this), 2200);
    };

    submitGenerated = () => {
        this.setState({ page: "ListAllFlights"});
    };

    restartApp = () => {
        this.setState({ page: "FindFlights"});
    };

    submitAbout = () => {
        this.setState({ page: "FindFlights"});
    };


    appletSwitch(s) {
        switch (s) {
            case "AboutPage":
                return <AboutPage submitAbout={this.submitAbout}/>;
            case "FindFlights":
                return <FindFlights submitDestination={this.submitDestination}/>;
            case "ListFlights":
                return <ListFlights submitFlight={this.submitFlight} restartApp={this.restartApp}/>;
            case "CustomerInfo":
                return <CustomerInfo submitCustomerInfo={this.submitCustomerInfo} restartApp={this.restartApp}/>;
            case "Payment":
                return <Payment submitPayment={this.submitPayment} restartApp={this.restartApp}/>;
            case "PickSeat":
                return <PickSeat submitSeat={this.submitSeat} restartApp={this.restartApp}/>;
            case "RefundPage":
                return <RefundPage submitRefund={this.submitRefund}/>;
            case "ListAllFlights":
                return <ListAllFlights />;
            case "AirlinePortal":
                return <AirlinePortal />;
            case "GeneratedNumber":
                return <GeneratedNumber submitGenerated={this.submitGenerated} restartApp={this.restartApp}/>;
            case "CheckTicket":
                return <CheckTicket />;
            case "CheckBooking":
                return <CheckBooking />;
            default:
                return <div></div>;
        }
    }

    render() {
        return(
            <div>
                <Nav nh={this.navHandler}/>
                <section className="hero is-fullheight-with-navbar">
                    <div className="section">
                        {this.appletSwitch(this.state.page)}
                    </div>
                </section>
            </div>
        );
    }
}

export default HomePage;
