import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";

class ListFlights extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
          flights: [],
          flight_id: 0,
        };
        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.backButton = this.backButton.bind(this);
      }

      handleChange(e) {
        this.setState({ [e.target.name]: e.target.value });
      }



      handleSubmit(e) {
        e.preventDefault();
        var i;
        var check = false;
        var waitlistfull = false;
        for (i = 0; i < this.state.flights.length; i++) {  
          // eslint-disable-next-line
          if(this.state.flight_id == this.state.flights[i].flight_id)
          {
            check = true;
            //console.log(this.state.flights[i].waitlist - this.state.current_user[0].travelers)
            // eslint-disable-next-line
            if (this.state.flights[i].seats_available - this.state.current_user[0].travelers < 0)
            {
              if(this.state.flights[i].waitlist - this.state.current_user[0].travelers < 0)
              {
                  check = false;
                  waitlistfull = true;
                  alert(
                    "The flight and waitlist is full: Please pick another flight"
                  );
              }
              else
              {
                alert(
                  "This flight is full: You will be placed on a waitlist"
                );
              } 
            }
          }
        }
        if (check === true)
        {
          fetch("http://localhost:8080/api/selected_flight", {
            method: "post",
            headers: new Headers({
              "content-type": "application/json",
            }),
            mode: "cors",
            credentials: "include",
            body: JSON.stringify(this.state),
          })
          this.props.submitFlight()
        }
        else if (check === false && waitlistfull !== true)
        {
          alert(
            "Invalid Flight Id: Please type in a flight id from the list (Capitalization Matters)"
          );
        }
      }


      backButton(e)
      {
        e.preventDefault();
        this.props.restartApp()
      }

      componentDidMount() {
        fetch("http://localhost:8080/api/list_flights", {
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
          fetch("http://localhost:8080/api/get_currentuser", {
            method: "get",
            credentials: "include",
            mode: "cors",
        })
            .then((res) => res.json())
            .then((current_user) => {
                this.setState({ current_user }, () =>
                console.log("User fetched...", current_user[0].travelers)
                );
              } 
        
          )

      }

   render() {
    return (
            <div className="container">
                <div
                class="is-overlay has-text-centered single-spaced"
                style={{ top: 30 }}
                >
                <div class="container">
                <form className="box" onSubmit={this.handleSubmit}>
                        <div className="field">
                            <label className="label">Enter Chosen Flight Id</label>
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
                            <button class="button is-danger" onClick={this.backButton}> Restart</button>
                            </nav>
                        </div>
                    </form>
                    <div class="box">
                    <h1 class="title has-text-centered">Found Flights</h1>
                    <table class="table is-fullwidth" >
                        <thead>
                            <tr>
                                <th>Flight Id</th>
                                <th>Flight Number</th>
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
                    {this.state.flights.length === 0 ? <p>No flights for specified requirements</p> : <div />}
                    </div>
                    
                    
                </div>
                </div>
            </div>
        );
    }
}

export default ListFlights;
