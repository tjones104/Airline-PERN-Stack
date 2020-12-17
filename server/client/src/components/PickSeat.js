import React from 'react'
import "react-bulma-components/dist/react-bulma-components.min.css";
 
class PickSeat extends React.Component  {
  constructor(props) {
    super(props);
    this.state = {
      seats: [],
      travelers:  [],
      isButtonDisabled: false,
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
    //Check for duplicate
    var valueArr = this.state.travelers.map(function(item){ return item.seat_no });
    var isDuplicate = valueArr.some(function(item, idx){ 
      // eslint-disable-next-line
      return valueArr.indexOf(item) != idx });

    //Check if exists
    let checker = (arr, target) => target.every(v => arr.includes(v));

    let seats1 = []
    for (var i = 0; i < this.state.seats.length; i++) {
      
      seats1[i] = (this.state.seats[i].seat_no)
    }
    let seats2 = []
    for (var j = 0; j < this.state.travelers.length; j++) {
      
      seats2[j] = (this.state.travelers[j].seat_no)
    }

    if (checker(seats1,seats2))
    {
      if (!isDuplicate)
    {
      this.setState({
        isButtonDisabled: true,
      });
      fetch("http://localhost:8080/api/selected_seat", {
        method: "post",
        headers: new Headers({
          "content-type": "application/json",
        }),
        mode: "cors",
        credentials: "include",
        body: JSON.stringify(this.state),
      })


      setTimeout(() => {   
      fetch("http://localhost:8080/api/post_boarding", {
        method: "post",
        headers: new Headers({
          "content-type": "application/json",
        }),
        mode: "cors",
        credentials: "include",
        body: JSON.stringify(this.state),
      })
      }, 2000);
      // alert(
      //   "Thank you for flying with us. Redirecting too flight list"
      // );
      this.props.submitSeat();
    }
    else{
      alert(
        "Duplicate Seats Chosen: Please make sure travelers have different seats numbers"
      );
    }
      
    }
    else{
      alert(
        "Invalid Seat Number: Please type in a seat number from the list (Capitalization Matters)"
      );
    }
  }

  backButton(e)
  {
    e.preventDefault();
    this.props.restartApp()
  }


  componentDidMount() {
    fetch("http://localhost:8080/api/list_seats", {
      method: "get",
      credentials: "include",
      mode: "cors",
    })
      .then((res) => res.json())
      .then((seats) =>
        this.setState({ seats }, () =>
          console.log("Seats fetched...", seats)
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
                var i;
                for (i = 0; i < this.state.current_user[0].travelers; i++) 
                {
                    this.setState({
                        travelers: this.state.travelers.concat([{ seat_no : ''}])
                    })
                }
                
        } 
        
    );
  }


  handleTravelerSeatChange = idx => evt => {
    const newTravelers = this.state.travelers.map((traveler, sidx) => {
        if (idx !== sidx) return traveler;
        return { ...traveler, seat_no: evt.target.value };
    });

    this.setState({ travelers: newTravelers });
};

render() {
return (
        <div className="container">
            <div
            class="is-overlay has-text-centered single-spaced"
            style={{ top: 30 }}
            >
            <div class="container">
            <div class="box">
            <h1 class="title has-text-centered">Available Seats</h1>
            
            <div class="columns is-gapless">
            <div class="column">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" >
                    <thead>
                        <tr>
                            <th>A</th>

                        </tr>
                    </thead>
                    {this.state.seats.map((seats) => (
                          <tr key={seats.seat_no}>
                            {seats.seat_no.includes("A") ? <td>{seats.seat_no}</td> : undefined}
                          </tr>
                        ))}
                </table>
                </div>
                <div class="column">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" >
                    <thead>
                        <tr>
                            <th>B</th>

                        </tr>
                    </thead>
                    {this.state.seats.map((seats) => (
                          <tr key={seats.seat_no}>
                            {seats.seat_no.includes("B") ? <td>{seats.seat_no}</td> : undefined}
                          </tr>
                        ))}
                </table>
                </div>
                <div class="column">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" >
                    <thead>
                        <tr>
                            <th>C</th>

                        </tr>
                    </thead>
                    {this.state.seats.map((seats) => (
                          <tr key={seats.seat_no}>
                            {seats.seat_no.includes("C") ? <td>{seats.seat_no}</td> : undefined}
                          </tr>
                        ))}
                </table>
                </div>
                <div class="column">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" >
                    <thead>
                        <tr>
                            <th>D</th>

                        </tr>
                    </thead>
                    {this.state.seats.map((seats) => (
                          <tr key={seats.seat_no}>
                            {seats.seat_no.includes("D") ? <td>{seats.seat_no}</td> : undefined}
                          </tr>
                        ))}
                </table>
                </div>
                <div class="column">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" >
                    <thead>
                        <tr>
                            <th>E</th>

                        </tr>
                    </thead>
                    {this.state.seats.map((seats) => (
                          <tr key={seats.seat_no}>
                            {seats.seat_no.includes("E") ? <td>{seats.seat_no}</td> : undefined}
                          </tr>
                        ))}
                </table>
                </div>
                <div class="column">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" >
                    <thead>
                        <tr>
                            <th>F</th>

                        </tr>
                    </thead>
                    {this.state.seats.map((seats) => (
                          <tr key={seats.seat_no}>
                            {seats.seat_no.includes("F") ? <td>{seats.seat_no}</td> : undefined}
                          </tr>
                        ))}
                </table>
                </div>
                </div>
                </div>
                <form className="box" onSubmit={this.handleSubmit}>
                {this.state.travelers.map((traveler, idx) => (
                  <div className="Traveler">
                        <div className="field">
                            <label className="label">{`Enter Traveler ${idx + 1}'s Seat Number`}</label>
                            <div className="control has-icons-left">
                            <input
                                type="text"
                                placeholder="* required"
                                className="input"
                                name="seat_no"
                                onChange={this.handleTravelerSeatChange(idx)}
                                required
                            />
                            </div>
                            &nbsp;
                        </div>
                    </div>
                    ))}
                            
                        <nav class="level">
                          <div className="field has-text-centered">
                          <input
                          type="submit"
                          className="button is-link"
                          value="Submit"
                          disabled={this.state.isButtonDisabled} 
                          />
                          </div>
                          <button class="button is-danger" onClick={this.backButton} disabled={this.state.isButtonDisabled} > Restart</button>
                        </nav>
                    </form>
            </div>
            </div>
        </div>
    );
  }
}

  export default PickSeat;
