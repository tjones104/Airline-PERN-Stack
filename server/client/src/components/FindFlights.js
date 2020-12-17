import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";

//Script to get todays date
var today = new Date();
var dd = today.getDate();
var mm = today.getMonth() + 1;
var yyyy = today.getFullYear();
if (dd < 10) {
  dd = "0" + dd;
}
if (mm < 10) {
  mm = "0" + mm;
}
today = yyyy + "-" + mm + "-" + dd;


class FindFlights extends React.Component {
        constructor(props) {
        super(props);
        this.state = {
            departing_airport: 'HOU',
            arrival_airport: 'LAX',
            date: new Date(),
            travelers: 1,
            fair_conditions: 'Economy'
        };
        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleChange = this.handleChange.bind(this);
      }

      handleChange(e) {
        this.setState({[e.target.name]: e.target.value})
      }

      handleSubmit(e) {
        e.preventDefault();
        // eslint-disable-next-line
        if(this.state.departing_airport != this.state.arrival_airport)
        {
            // eslint-disable-next-line
            if(this.state.date != undefined && this.state.date >= today)
        {
            fetch("http://localhost:8080/api/flight_requirements", {
            method: "post",
            headers: new Headers({
                "content-type": "application/json",
            }),
            mode: "cors",
            credentials: "include",
            body: JSON.stringify(this.state),
            })
            this.props.submitDestination();
        }
            else
            {
                alert(
                    "Invalid Date: You've selected a date in the past!"
                );
            }
        }
        else
        {
            alert(
                "Invalid Airport Selection: Departing Airport matches Arrival Airport"
            );
        }
        
        
      }

    render() {
        return (
                <div className="container">
                    <div className="columns is-centered">
                    <div className="column is-3-desktop">
                        <form className="box" onSubmit={this.handleSubmit}>
                        <h1 class="title has-text-centered">Find Flights</h1>
                        <div className="field">
                            <label className="label">Departing Airport</label>
                            <div className="select">
                            <select name="departing_airport" value={this.state.departing_airport} onChange={this.handleChange}>
                                <option>HOU</option>
                                <option>JFK</option>
                                <option>LAX</option>
                                <option>ORD</option>
                                <option>MIA</option>
                            </select>
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Arrival Airport</label>
                            <div className="select">
                            <select name="arrival_airport" value={this.state.arrival_airport} onChange={this.handleChange}>
                                <option>LAX</option>
                                <option>JFK</option>
                                <option>ORD</option>
                                <option>MIA</option>
                                <option>HOU</option>
                            </select>
                            </div>
                        </div>
                        <div>
                            <label className="label">Date</label>
                            <div className="control has-icons-left">
                            <input
                                type="date"
                                className="input"
                                name="date" value={this.state.date} onChange={this.handleChange}
                                required
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-calendar"></i>
                            </span>
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Travelers</label>
                            <div className="control has-icons-left">
                            <input
                                type="number"
                                //placeholder="1"
                                min = '1'
                                max = '10'
                                className="input"
                                name="travelers" value={this.state.travelers} onChange={this.handleChange}
                                required
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-dollar"></i>
                            </span>
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Fare Conditions</label>
                            <div className="select">
                            <select name="fair_conditions" value={this.state.fair_conditions} onChange={this.handleChange}>
                                <option>Economy</option>
                                <option>Comfort</option>
                                <option>Business</option>
                            </select>
                        </div>
                        </div>
                        <div className="field has-text-centered">
                            <input
                            type="submit"
                            className="button is-link"
                            value="Find Flights"
                            />
                        </div>
                        </form>
                    </div>
                    </div>
                </div>
       );
    }
  }

export default FindFlights;
    