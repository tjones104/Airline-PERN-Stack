import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";

class CheckBooking extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
          passengers: [],
          booking_no: 0,
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
        var checkBooking = false;
        //console.log(this.state.booking_no)
        for(var i = 0; i < this.state.bookings.length; i++)
        {
            //console.log(this.state.bookings[i].book_ref)
            // eslint-disable-next-line
            if(this.state.booking_no == this.state.bookings[i].book_ref)
            {

                //console.log("yes")
                checkBooking = true;
            }
        }
        if(checkBooking === true)
        {
          this.setState({
            isActive: true
          })
          //console.log(this.state.booking_no)
          fetch("http://localhost:8080/api/list_booking", {
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
        }
        else{
          this.setState({
            isActive: false
          })
          setTimeout(() => {
          alert(
            "Invalid Booking Number: This number does not exist in our system"
          );}, 50)
        }
      }


      componentDidMount() {
        fetch("http://localhost:8080/api/get_bookings", {
          method: "get",
          credentials: "include",
          mode: "cors",
        })
          .then((res) => res.json())
          .then((bookings) =>
            this.setState({ bookings }, () =>
              console.log("Bookings fetched...", bookings)
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
                        <h1 class="title has-text-centered">Check your Booking</h1>
                        
                        <div className="field">
                            <label className="label">Booking Reference Number</label>
                            <div className="control has-icons-left">
                            <input
                                type="number"
                                placeholder="* required"
                                className="input"
                                name="booking_no" onChange={this.handleChange}
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
                    <div class="box has-text-centered">
                    <h1 class="title has-text-centered">Your Booking Information</h1>
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
                    {this.state.passengers.length === 0 ? <p >Since you refunded you have no tickets for this bookings</p> : <div />}
                    </div>
                </div>  : null }
                </div>
            </div>
        );
    }
}

export default CheckBooking;
