import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";

class CheckTicket extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
          passengers: [],
          flight: [],
          ticket_no: 0,
          isActive:false,
        };

        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
      }

      handleChange(e) {
        this.setState({[e.target.name]: e.target.value})
      }

      handleSubmit(e)
      {
        e.preventDefault();
        var checkTicket = false;
        //console.log(this.state.booking_no)
        for(var i = 0; i < this.state.passengerinfo.length; i++)
        {
            //console.log(this.state.bookings[i].book_ref)
            // eslint-disable-next-line
            if(this.state.ticket_no == this.state.passengerinfo[i].ticket_no)
            {

                //console.log("yes")
                checkTicket = true;
            }
        }

        if(checkTicket === true)
        {
          this.setState({
            isActive: true
          })
          //console.log(this.state.ticket_no)
          fetch("http://localhost:8080/api/list_ticket", {
            method: "post",
            headers: new Headers({
                "content-type": "application/json",
            }),
            mode: "cors",
            credentials: "include",
            body: JSON.stringify(this.state),
            })
               .then((res) => res.json())
                .then((passengers) =>
            this.setState({ passengers }, () =>
              console.log("Passengers fetched...", passengers)
            )
        );
        fetch("http://localhost:8080/api/list_ticketflight", {
          method: "post",
          headers: new Headers({
              "content-type": "application/json",
          }),
          mode: "cors",
          credentials: "include",
          body: JSON.stringify(this.state),
          })
             .then((res) => res.json())
              .then((flight) =>
          this.setState({ flight }, () =>
            console.log("Passengers fetched...", flight)
          )
      );
        }
        else{
          this.setState({
            isActive: false
          })
          setTimeout(() => {
          alert(
            "Invalid Ticket Number: This number does not exist in our system"
          );}, 50)
          }
      }


      componentDidMount() {
        fetch("http://localhost:8080/api/listall_passengers", {
          method: "get",
          credentials: "include",
          mode: "cors",
        })
          .then((res) => res.json())
          .then((passengerinfo) =>
            this.setState({ passengerinfo }, () =>
              console.log("Passengers Info fetched...", passengerinfo)
            )
          );
      }



   render() {
    return (
            <div className="container">
                <div
                class="is-overlay"
                style={{ top: 30 }}
                >
                    <form className="box" onSubmit={this.handleSubmit}>
                        <h1 class="title has-text-centered">Check your ticket and flight information</h1>
                        
                        <div className="field">
                            <label className="label">Ticket Number</label>
                            <div className="control has-icons-left">
                            <input
                                type="number"
                                placeholder="* required"
                                className="input"
                                name="ticket_no" onChange={this.handleChange}
                                required
                            />
                           
                            </div>
                        </div>
                        <div className="field has-text-centered">
                            <input
                            type="submit"
                            className="button is-link"
                            value="Submit"
                            />
                        </div>
                        </form>
                        {this.state.isActive ?  
                <div class="container">
                    <div class="box">
                    <h1 class="title has-text-centered">Your Ticket Information</h1>
                    <table class="table is-fullwidth" >
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone Number</th>
                                <th>Flight Id</th>
                                <th>Ticket Number</th>
                                <th>Booking Reference</th>
                                <th>Seat Number</th>

                            </tr>
                        </thead>
                        {this.state.passengers.map((passengers) => (
                          <tr key={passengers.passenger_id}>
                            <td>{passengers.passenger_name}</td>
                            <td>{passengers.email}</td>
                            <td>{passengers.phone}</td>
                            <td>{passengers.flight_id}</td>
                            <td>{passengers.ticket_no}</td>
                            <td>{passengers.book_ref}</td>
                            <td>{passengers.seat_no}</td>
                          </tr>
                        ))}
                    </table>
                    </div>
                    <div class="box">
                    <h1 class="title has-text-centered">Your Flight Information</h1>
                    <table class="table is-fullwidth" >
                        <thead>
                            <tr>
                                <th>Flight Id</th>
                                <th>Flight Number</th>
                                <th>Departure Airport</th>
                                <th>Arrival Airport</th>
                                <th>Status</th>
                                <th>Departing</th>
                                <th>Arriving</th>
                                <th>Boarding Time</th>
                                <th>Gate</th>
                                <th>Arrival Gate</th>
                                <th>Baggage Claim Number</th>
                                <th>Movie</th>
                                <th>Meal</th>

                            </tr>
                        </thead>
                        {this.state.flight.map((flight) => (
                          <tr key={flight.flight_id}>
                            <td>{flight.flight_id}</td>
                            <td>{flight.flight_no}</td>
                            <td>{flight.departure_airport}</td>
                            <td>{flight.arrival_airport}</td>
                            <td>{flight.status}</td>
                            <td>{flight.scheduled_departure}</td>
                            <td>{flight.scheduled_arrival}</td>
                            <td>{flight.boading_time}</td>
                            <td>{flight.gate}</td>
                            <td>{flight.arrival_gate}</td>
                            <td>{flight.baggage_claim_no}</td>
                            <td>{flight.movie}</td>
                            <td>{flight.meal}</td>
                          </tr>
                        ))}
                    </table>
                    </div>
                </div> : null }
                </div>
            </div>
        );
    }
}

export default CheckTicket;
