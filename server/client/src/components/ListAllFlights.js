import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";

class ListAllFlights extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
          flights: [],
          flight_id: 0,
          foundFlights: false,
        };

        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleChange = this.handleChange.bind(this);
      }




      handleChange(e) {
        this.setState({ [e.target.name]: e.target.value });
      }



      handleSubmit(e) {
        e.preventDefault();
        var i;
        var check = false;
        for (i = 0; i < this.state.flights.length; i++) {  
          // eslint-disable-next-line
          if(this.state.flight_id == this.state.flights[i].flight_id)
          {
            check = true;
          }
        }
        if (check === true)
        {
          fetch("http://localhost:8080/api/search_flights", {
            method: "post",
            headers: new Headers({
              "content-type": "application/json",
            }),
            mode: "cors",
            credentials: "include",
            body: JSON.stringify(this.state),
          }).then((res) => res.json())
          .then((flightsFound) =>
            this.setState({ flightsFound }, () =>
              console.log("Flights fetched...", flightsFound)
            )
          );
          setTimeout(function(){this.setState({
            foundFlights: true
        })}.bind(this), 500);
        }
        else{
          alert(
            "Invalid Flight Id: There is no flight with this flight id"
          );
        }
      }




      componentDidMount() {
        fetch("http://localhost:8080/api/listall_flights", {
          method: "get",
          credentials: "include",
          mode: "cors",
        })
          .then((res) => res.json())
          .then((flights) =>
            this.setState({ flights }, () =>
              console.log("Flights fetched...", flights)
            )
          );
      }

   render() {
    return (
            <div className="container">
                <div
                class="is-overlay has-text-centered single-spaced"
                >
                <div class="container">
                <form className="box" onSubmit={this.handleSubmit}>
                        <h1 class="title">Search Flights</h1>
                        <div className="field">
                            <label className="label">Enter Flight Id</label>
                            <div className="control has-icons-left">
                            <input
                                type="number"
                                placeholder="* required"
                                className="input"
                                name="flight_id"
                                onChange={this.handleChange}
                                required
                            />
                            </div>
                            &nbsp;
                            <nav class="level">                       
                            <div className="field has-text-centered">
                            <input
                            type="submit"
                            className="button is-link"
                            value="Submit"
                            />
                            </div>
                            </nav>
                        </div>
                    </form>
                    {this.state.foundFlights ? 
                    <div class="box">
                    <h1 class="title has-text-centered">Found Flights</h1>
                    <table class="table is-fullwidth" >
                        <thead>
                            <tr>
                                <th>Flight Id</th>
                                <th>Flight Number</th>
                                <th>Departure Airport</th>
                                <th>Arrival Airport</th>
                                <th>Status</th>
                                <th>Depart</th>
                                <th>Arrive</th>
                                <th>Seats Available</th>
                                <th>Seats Booked</th>
                                <th>Waitlist</th>
                                <th>Movie</th>
                                <th>Meal</th>

                            </tr>
                        </thead>
                        
                        {this.state.flightsFound.map((flightsFound) => (
                          <tr key={flightsFound.flight_id}>
                            <td>{flightsFound.flight_id}</td>
                            <td>{flightsFound.flight_no}</td>
                            <td>{flightsFound.departure_airport}</td>
                            <td>{flightsFound.arrival_airport}</td>
                            <td>{flightsFound.status}</td>
                            <td>{flightsFound.scheduled_departure}</td>
                            <td>{flightsFound.scheduled_arrival}</td>
                            <td>{flightsFound.seats_available}</td>
                            <td>{flightsFound.seats_booked}</td>
                            <td>{flightsFound.waitlist}</td>
                            <td>{flightsFound.movie}</td>
                            <td>{flightsFound.meal}</td>
                          </tr>
                        ))}
                    </table>
                    {this.state.flightsFound.length === 0 ? <p >No flights with that flight id found</p> : <div />}
                    </div> : null }
                    <div class="box">
                    <h1 class="title has-text-centered">Full Flight List</h1>
                    <table class="table is-fullwidth" >
                        <thead>
                            <tr>
                                <th>Flight Id</th>
                                <th>Flight Number</th>
                                <th>Departure Airport</th>
                                <th>Arrival Airport</th>
                                <th>Status</th>
                                <th>Depart</th>
                                <th>Arrive</th>
                                <th>Seats Available</th>
                                <th>Seats Booked</th>
                                <th>Waitlist</th>
                                <th>Movie</th>
                                <th>Meal</th>

                            </tr>
                        </thead>
                        
                        {this.state.flights.map((flights) => (
                          <tr key={flights.flight_id}>
                            <td>{flights.flight_id}</td>
                            <td>{flights.flight_no}</td>
                            <td>{flights.departure_airport}</td>
                            <td>{flights.arrival_airport}</td>
                            <td>{flights.status}</td>
                            <td>{flights.scheduled_departure}</td>
                            <td>{flights.scheduled_arrival}</td>
                            <td>{flights.seats_available}</td>
                            <td>{flights.seats_booked}</td>
                            <td>{flights.waitlist}</td>
                            <td>{flights.movie}</td>
                            <td>{flights.meal}</td>
                          </tr>
                        ))}
                    </table> 
                    {this.state.flights.length === 0 ? <p >No flights found, this message being here means the server is not on</p> : <div />}
                    </div>
                </div>
                </div>
            </div>
        );
    }
}

export default ListAllFlights;
