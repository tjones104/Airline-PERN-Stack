import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";

class RefundPage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
          book_ref: 0,
          card_no: 0,
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
        //console.log(this.state.book_ref)
        var checkTickets = false;
        var checkCardBooking = false;
        for(var i = 0; i < this.state.passengers.length; i++)
        {
            //console.log(this.state.passengers[i].book_ref)
            // eslint-disable-next-line
            if(this.state.book_ref == this.state.passengers[i].book_ref)
            {
                //console.log("yes")
                checkTickets = true;
            }
        }
        for(var j = 0; j < this.state.payments.length; j++)
        {
            // console.log(this.state.payments[i].book_ref)
            // console.log(this.state.payments[i].card_number)
            // eslint-disable-next-line
            if(this.state.book_ref == this.state.payments[j].book_ref && this.state.card_no == this.state.payments[j].card_number)
            {
                //console.log("yes")
                checkCardBooking = true;
            }
        }
        if(checkCardBooking === true)
        {
            if (checkTickets === true)
            {
            fetch("http://localhost:8080/api/refundTicket", {
                method: "post",
                headers: new Headers({
                    "content-type": "application/json",
                }),
                mode: "cors",
                credentials: "include",
                body: JSON.stringify(this.state),
                })
                setTimeout(() => {  
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
                ); }, 500);
            alert(
                "Refund Successful"
            );
            }
            else
            {
                alert(
                    "There are no tickets for this booking number"
                );
            }
        }
        else
        {
            alert(
                "Invalid Book Reference Number and Card Number combination"
            );
        }
        
        
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
        fetch("http://localhost:8080/api/get_payments", {
        method: "get",
        credentials: "include",
        mode: "cors",
        })
            .then((res) => res.json())
            .then((payments) =>
                this.setState({ payments }, () =>
                console.log("Payments fetched...", payments)
                )
            );
      }


      render(){
          return(
            <div className="container">
                <div
                class="is-overlay"
                style={{ top: 30 }}
                >
                    <form className="box" onSubmit={this.handleSubmit}>
                        
                        <h1 class="title has-text-centered">Refund</h1>
                        <div class="block has-text-centered">
                            <strong>Please note that when your refund is issued your ticket/s will be canceled.</strong>
                        </div>
                        <div className="field">
                            <label className="label">Booking Referral Code</label>
                            <div className="control has-icons-left">
                            <input
                                type="number"
                                placeholder="* required"
                                className="input"
                                name="book_ref" onChange={this.handleChange}
                                required
                            />
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Card Number</label>
                            <div className="control has-icons-left">
                            <input
                                type="number"
                                placeholder="* required"
                                className="input"
                                name="card_no" onChange={this.handleChange}
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
                </div>
            </div>
          );
          }
    }
export default RefundPage;