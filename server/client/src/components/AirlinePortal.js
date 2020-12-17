import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";

class AirlinePortal extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
          passengers: [],
        };
      }



      backButton(e)
      {
        e.preventDefault();
        this.props.restartApp()
      }

      componentDidMount() {
        fetch("http://localhost:8080/api/listall_passengers", {
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
                    <h1 class="title">Passengers</h1>
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
                    {this.state.passengers.length === 0 ? <p>No passengers yet</p> : <div />}
                    </div>
                </div>
                </div>
            </div>
        );
    }
}

export default AirlinePortal;
