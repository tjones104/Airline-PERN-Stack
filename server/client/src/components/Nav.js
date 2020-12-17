import React, { Component } from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";
import "../App.css";

class Nav extends Component {
  constructor(props) {
    super(props);
    this.click = this.click.bind(this);
  }

  click = (e) => {
    this.props.nh(e.currentTarget.id);
  };

  

  render() {
    return (
      <nav className="navbar">
        <div className="navbar-menu">
          <div className="navbar-start">
          <div
              id="AirlinePortal"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              Airline Portal
            </div>
          </div>

          <div className="navbar-end">
          <div
              id="AboutPage"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              About
            </div>
            <div
              id="FindFlights"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              Find Flights
            </div>
            {/* <div
              id="ListFlights"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              List Found Flights
            </div>
            <div
              id="CustomerInfo"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              Customer Information
            </div>
            <div
              id="Payment"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              Payment
            </div> */}
            {/* <div
              id="PickSeat"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              Seats
            </div> 
            <div
              id="GeneratedNumber"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              Generated Numbers
            </div> */}
            <div
              id="CheckTicket"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              Check Ticket
            </div>
            <div
              id="CheckBooking"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              Check Booking
            </div>
            <div
              id="RefundPage"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              Refund
            </div>
            <div
              id="ListAllFlights"
              className="navbar-item navbar-item-hover"
              onClick={this.click}
            >
              View All Flights
            </div>
          </div>
        </div>
      </nav>
    );
  }
}


export default Nav;
