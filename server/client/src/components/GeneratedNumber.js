import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";

class GerneratedNumber extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
          passengers: [],
          flight: [],
        };
        this.handleSubmit = this.handleSubmit.bind(this);
        this.backButton = this.backButton.bind(this);
      }

      handleSubmit(e)
      {
        e.preventDefault();
        alert(
            "Make sure to write down your Ticket Number and Booking Reference for future use! Thank you for flying with us, you will now be redirected to the full flight list"
        );
        this.props.submitGenerated()
      }

      backButton(e)
      {
        e.preventDefault();
        this.props.restartApp()
      }

      componentDidMount() {
        fetch("http://localhost:8080/api/list_generated", {
          method: "get",
          credentials: "include",
          mode: "cors",
        })
          .then((res) => res.json())
          .then((passengers) =>
            this.setState({ passengers }, () =>
              console.log("Passengers fetched...", passengers)
            )
          );
        fetch("http://localhost:8080/api/list_passengerflight", {
        method: "get",
        credentials: "include",
        mode: "cors",
        })
            .then((res) => res.json())
            .then((flight) =>
                this.setState({ flight }, () =>
                console.log("Flight fetched...", flight)
                )
            );
      }

   render() {
    return (
            <div className="container">
                <div
                class="is-overlay has-text-centered single-spaced"
                style={{ top: 30 }}
                >
                <div class="container">
                    <div class="box">
                    <h1 class="title">Your Ticket Information</h1>
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
                    <h6 class="title is-6">Make sure you write down your Ticket Number and Booking Reference for future use!</h6>
                    </div>
                    <div class="box">
                    <h1 class="title">Your Flight Information</h1>
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
                    <form className="box" onSubmit={this.handleSubmit}>
                    <nav class="level">
                          <div className="field has-text-centered">
                          <input
                          type="submit"
                          className="button is-link"
                          value="Next"
                          />
                          </div>
                          <button class="button is-danger" onClick={this.backButton}> Restart</button>
                        </nav>
                    </form>
                </div>
                </div>
            </div>
        );
    }
}

export default GerneratedNumber;
