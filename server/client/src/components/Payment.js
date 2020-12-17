import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";

class Payment extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            current_user:[],
            total_price: 0,
            taxes: 0,
            discounts: 0,
            card_number: '',
            security_code: '',
            full_name: '',
            billing_address: ''
        };
        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.backButton = this.backButton.bind(this);
      }

      handleChange(e) {
        this.setState({[e.target.name]: e.target.value})
      }

      handleSubmit(e) {
        e.preventDefault();
        function hasNumber(myString) {
            return /\d/.test(myString);
          }
        function isValid(str){
            return !/[~`!@#$%^&*+=\-[\]\\';,/{}|\\":<>?()._]/g.test(str);
        }


        if(isNaN(this.state.card_number) === false)
        {
            
            if(isNaN(this.state.security_code) === false)
            {
                if(hasNumber(this.state.full_name) === false && isValid(this.state.full_name) === true)
                {
                //console.log(this.state.total_price)
                let tax = (this.state.total_price / 1.075) * 0.075
                this.setState({ taxes: tax }, () => {
                    //console.log(this.state.taxes, 'taxes')
                    fetch("http://localhost:8080/api/payment", {
                method: "post",
                headers: new Headers({
                    "content-type": "application/json",
                }),
                mode: "cors",
                credentials: "include",
                body: JSON.stringify(this.state),
                })
                this.props.submitPayment();
                }); 
                }
                else{
                    alert(
                        "Invalid Name: Please enter valid name/s (no numbers or special characters)"
                      );
                }
            }
            else
            {
                alert(
                    "Invalid Security Code: Please type in a 3 digit security code"
                  );
            }
        }
        else
        {
            alert(
                "Invalid Card Number: Please type in a 16 digit card number"
              );
        }        
      }

      backButton(e)
    {
      e.preventDefault();
      this.props.restartApp()
    }

      componentDidMount() {
        fetch("http://localhost:8080/api/get_currentuser", {
          method: "get",
          credentials: "include",
          mode: "cors",
        })
          .then((res) => res.json())
          .then((current_user) =>
            this.setState({ current_user }, () =>
              console.log("User fetched...", current_user[0])
            )
        );
        fetch("http://localhost:8080/api/pricing_module", {
        method: "get",
        credentials: "include",
        mode: "cors",
        })
        .then((res) => res.json())
        .then((total_price) =>
            this.setState({ total_price }, () =>
            console.log("Total Price fetched...", total_price)
            )
        );
      }
    
    
    render() {
        return (
                <div className="container">
                    <div className="columns is-multiline is-mobile is-centered">
                    <div className="columns is-half ">
                    <div className="column is-11-desktop">
                        <form className="box">
                        <h1 class="title has-text-centered">Pricing Information</h1>
                        <div className="field">
                            <label className="label">Travelers</label>
                            <div className="control has-icons-left">
                            <input
                                type="number"
                                className="input"
                                name="travelers" 
                                value={this.state.current_user.map((current_user) => current_user.travelers)}
                                disabled
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-dollar"></i>
                            </span>
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Fare Condition</label>
                            <div className="control has-icons-left">
                            <input
                                type="text"
                                className="input"
                                name="travelers" 
                                value={this.state.current_user.map((current_user) => current_user.fair_conditions)}
                                disabled
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-dollar"></i>
                            </span>
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Fare Condition Price</label>
                            <div className="control has-icons-left">
                            <input
                                type="number"
                                className="input"
                                name="travelers" 
                                value= {(this.state.total_price / 1.075) / (this.state.current_user.map((current_user) => current_user.travelers))}
                                disabled
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-dollar"></i>
                            </span>
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Taxes</label>
                            <div className="control has-icons-left">
                            <input
                                type="number"
                                className="input"
                                name="travelers" 
                                value= {(this.state.total_price / 1.075) * 0.075}
                                disabled
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-dollar"></i>
                            </span>
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Total Price</label>
                            <div className="control has-icons-left">
                            <input
                                type="number"
                                className="input"
                                name="travelers" 
                                value = {this.state.total_price}
                                disabled
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-dollar"></i>
                            </span>
                            </div>
                        </div>
                        </form>
                    </div>
                    </div>
                    <div className="columns is-half">
                    <div className="column is-11-desktop">
                        <form className="box" onSubmit={this.handleSubmit}>
                        <h1 class="title has-text-centered">Credit Card Details</h1>
                        <div className="field">
                            <label className="label">Card Number</label>
                            <div className="control has-icons-left">
                            <input
                                type="text"
                                minLength = '16'
                                maxLength = '16'
                                placeholder="* required"
                                className="input"
                                name="card_number" 
                                value={this.state.card_number} 
                                onChange={this.handleChange}
                                required
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-lock"></i>
                            </span>
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Security Code</label>
                            <div className="control has-icons-left">
                            <input
                                type="text"
                                minLength = '3'
                                maxLength = '3'
                                placeholder="* required"
                                className="input"
                                name="security_code"
                                value={this.state.security_code} 
                                onChange={this.handleChange}
                                required
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-lock"></i>
                            </span>
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Full name as it appears on your card</label>
                            <div className="control has-icons-left">
                            <input
                                type="text"
                                minLength = '3'
                                placeholder="* required"
                                className="input"
                                name="full_name" 
                                value={this.state.full_name} 
                                onChange={this.handleChange}
                                required
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-lock"></i>
                            </span>
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">Billing Address</label>
                            <div className="control has-icons-left">
                            <input
                                type="text"
                                minLength = '3'
                                placeholder="* required"
                                className="input"
                                name="billing_address" 
                                value={this.state.billing_address} 
                                onChange={this.handleChange}
                                required
                            />
                            <span className="icon is-small is-left">
                                <i className="fa fa-lock"></i>
                            </span>
                            </div>
                        </div>
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
                        
                        </form>
                    </div>
                </div>
            </div>
        </div>
                
       );
    }
  }

export default Payment;
    
