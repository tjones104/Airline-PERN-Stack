import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";

class CustomerInfo extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            travelers: [],
            name: '',
            email: '',
            phone: '',
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
        //console.log(this.state.current_user[0].travelers)
        // eslint-disable-next-line
        function hasNumber(myString) {
            return /\d/.test(myString);
          }
        function isValid(str){
            return !/[~`!@#$%^&*+=\-[\]\\';,/{}|\\":<>?()._]/g.test(str);
        }
        function isEmail(str){
            return /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(str);
        }
        var i;
        var phoneCheck = true;
        var nameCheck = true;
        var emailCheck = true;
        for (i = 0; i < this.state.current_user[0].travelers; i++) 
        { 
            if(isNaN(this.state.travelers[i].phone))
            {
                phoneCheck = false;
            }
        }
        for (i = 0; i < this.state.current_user[0].travelers; i++) 
        { 
            if(hasNumber(this.state.travelers[i].name) === true || !isValid(this.state.travelers[i].name) === true)
            {
                nameCheck = false;
            }
        }
        for (i = 0; i < this.state.current_user[0].travelers; i++) 
        { 
            if(!isEmail(this.state.travelers[i].email) === true)
            {
                emailCheck = false;
            }
        }
        if (nameCheck === true && phoneCheck === true && emailCheck === true)
        {
                for (i = 0; i < this.state.current_user[0].travelers; i++) 
            { 
                    //console.log(this.state.travelers[i])
                    fetch("http://localhost:8080/api/customer_info", {
                    method: "post",
                    headers: new Headers({
                    "content-type": "application/json",
                    }),
                    mode: "cors",
                    credentials: "include",
                    body: JSON.stringify(this.state.travelers[i]),
                })
            }
            this.props.submitCustomerInfo();
        }
        else if (nameCheck === false)
        {
            alert(
                "Please enter valid name/s (no numbers or special characters)"
            )
        }
        else if (phoneCheck === false)
        {
            alert(
                "Please enter valid phone number/s"
            )
        }
        else if (emailCheck === false)
        {
            alert(
                "Please enter valid email address/es (must contain @ and a domain such as .com, .net, etc."
            )
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
            .then((current_user) => {
                this.setState({ current_user }, () =>
                console.log("User fetched...", current_user[0].travelers)
                );
                var i;
                for (i = 0; i < this.state.current_user[0].travelers; i++) 
                {
                    this.setState({
                        travelers: this.state.travelers.concat([{ name: '',
                        email: '',
                        phone: ''}])
                    })
                }
                
        } 
        
    )
    }
    

    handleTravelerNameChange = idx => evt => {
        const newTravelers = this.state.travelers.map((traveler, sidx) => {
            if (idx !== sidx) return traveler;
            return { ...traveler, name: evt.target.value };
        });

        this.setState({ travelers: newTravelers });
    };

    handleTravelerEmailChange = idx => evt => {
        const newTravelers = this.state.travelers.map((traveler, sidx) => {
            if (idx !== sidx) return traveler;
            return { ...traveler, email: evt.target.value };
        });
    
        this.setState({ travelers: newTravelers });
    };

    handleTravelerPhoneChange = idx => evt => {
        const newTravelers = this.state.travelers.map((traveler, sidx) => {
            if (idx !== sidx) return traveler;
            return { ...traveler, phone: evt.target.value };
        });
    
        this.setState({ travelers: newTravelers });
    };

    render() {
        return (
                <div className="container">
                    <div className="columns is-centered">
                    <div className="column is-4-desktop">
                        <form className="box" onSubmit={this.handleSubmit}>
                        <h1 class="title has-text-centered">Traveler Information</h1>
                        {this.state.travelers.map((traveler, idx) => (
                    <div className="Traveler">
                        <div className="field">
                            <label className="label">{`Traveler ${idx + 1} Full Name`}</label>
                            <div className="control has-icons-left">
                            <input
                                type="text"
                                minLength = '3'
                                placeholder="* required"
                                className="input"
                                name="name"
                                onChange={this.handleTravelerNameChange(idx)}
                                required
                            />
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">{`Traveler ${idx + 1} Email`}</label>
                            <div className="control has-icons-left">
                            <input
                                type="text"
                                minLength = '4'
                                maxLength = '50'
                                placeholder="* required"
                                className="input"
                                name="email"
                                onChange={this.handleTravelerEmailChange(idx)}
                                required
                            />
                            </div>
                        </div>
                        <div className="field">
                            <label className="label">{`Traveler ${idx + 1} Phone Number`}</label>
                            <div className="control has-icons-left">
                            <input
                                type="text"
                                minLength = '10'
                                maxLength = '10'
                                placeholder="* required"
                                className="input"
                                name="phone"
                                onChange={this.handleTravelerPhoneChange(idx)}
                                required
                            />
                            </div>
                        </div>         
                        &nbsp;
                        </div>
                    ))}
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
       );
    }
  }

export default CustomerInfo;
    