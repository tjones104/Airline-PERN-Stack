import React from "react";
import "react-bulma-components/dist/react-bulma-components.min.css";
import ERMODELPDF from '../imgs/ER Model.pdf';
import ERMODELWITHCARDPDF from '../imgs/ER Model With Cardinalities.pdf';

class AboutPage extends React.Component {
        constructor(props) {
        super(props);
        this.state = {
            isActive: true,
            isButtonDisabled: false,
            isSecure: false,
            isPopulating: false,
            resetdatabaseclicked: false,
        };
        this.handleSubmit = this.handleSubmit.bind(this);
        this.populateDatabase = this.populateDatabase.bind(this);
        this.resetDatabase = this.resetDatabase.bind(this);
      }

      resetDatabase(e){
        e.preventDefault();
        this.setState({
            isButtonDisabled: true,
            isSecure: true,
            resetdatabaseclicked: true,
        });
        
        fetch("http://localhost:8080/api/resetdatabase", {
            method: "post",
            headers: new Headers({
              "content-type": "application/json",
            }),
            mode: "cors",
            credentials: "include",
            body: JSON.stringify(this.state),
            })
        setTimeout(() => this.setState({ isButtonDisabled: false, isSecure: false,}), 5000);
        setTimeout(function(){this.setState({
            isActive: true
        })}.bind(this), 1000);
      }

      populateDatabase(e){
        e.preventDefault();
        this.setState({
            isActive: false,
            isPopulating: true,
            isButtonDisabled: true,
        })
        fetch("http://localhost:8080/api/populatetables", {
            method: "post",
            headers: new Headers({
              "content-type": "application/json",
            }),
            mode: "cors",
            credentials: "include",
            body: JSON.stringify(this.state),
            })
            setTimeout(() => this.setState({ isButtonDisabled: false, isPopulating: false,}), 5000);
      }


      handleSubmit(e) {
        e.preventDefault();
        this.props.submitAbout()
      }

    render() {
        return (
                <div className="container">
                    <div className="columns is-centered">
                    <div className="column is-7-desktop">
                    <div class="box">
                    <h1 class="title has-text-centered">About</h1>
                        <div class="block has-text-centered">
                        Welcome to our Airline Application. You can view our ER Model or Demo in the links below.
                        </div>
                        <div class="block has-text-centered">
                        You can check the transaction.sql or query.sql in the server folder to see all the sql statements.
                        </div>
                        &nbsp;
                        <div class="block has-text-centered">
                        <a href = {ERMODELPDF} target = "_blank" rel="noreferrer">ER Model</a>
                        </div>
                        <div class="block has-text-centered">
                        <a href = {ERMODELWITHCARDPDF} target = "_blank" rel="noreferrer">ER Model with only Primary and Foreign Keys</a>
                        </div>
                        <div class="block has-text-centered">
                        <a target="_blank" rel="noreferrer" href="https://youtu.be/B8iRDRgKk7M">Demo</a>
                        </div>
                        &nbsp;
                        <div class="block has-text-centered">
                        First please click the <strong>Reset Database</strong> button to create the tables in your account.
                        </div>
                        &nbsp;
                        {this.state.resetdatabaseclicked ?
                        <div class="block has-text-centered">
                        If you want to pre-populated the tables click the <strong>Pre-Populate</strong> button.
                        </div> : null }
                        &nbsp;
                        {this.state.resetdatabaseclicked ?
                        <div class="block has-text-centered">
                        If you pre-populated the tables, the flight with <strong>Flight ID 1001 </strong> is a special case flight you can use to test the waitlist. You can go to the <strong>View All Flights</strong> tab to see the requirements for that flight.
                        </div> : null }
                        &nbsp;
                        {this.state.resetdatabaseclicked ?
                        <div class="block has-text-centered">
                        If you want to look at the Airline Clerk side press the <strong>Airline Portal Tab</strong> in the top left. 
                        </div> : null }
                        &nbsp;
                        {this.state.resetdatabaseclicked ?
                        <div class="block has-text-centered">
                        If you want to start a application press the <strong>Start Application</strong> button below or the <strong>Find Flights Tab</strong>.
                        </div> : null }
                        &nbsp;
                        {this.state.resetdatabaseclicked ?
                        <div class="block has-text-centered">
                        If at anytime you want to change your reservation you can press the <strong>Restart</strong> button on any page during the application.
                        </div> : null }
                        &nbsp;
                        <nav class="level">
                            <div class="level-item has-text-centered">
                                <div className="field has-text-centered">
                                    <input
                                    type="submit"
                                    className="button is-danger"
                                    onClick={this.resetDatabase}
                                    disabled={this.state.isButtonDisabled}
                                    value="Reset Database"
                                    />
                                </div>
                            </div>
                            {this.state.resetdatabaseclicked ?
                            <div class="level-item has-text-centered">
                                <div className="field has-text-centered">
                                    <input
                                    type="submit"
                                    className="button is-success"
                                    onClick={this.handleSubmit}
                                    disabled={this.state.isButtonDisabled}
                                    value="Start Application"
                                    />
                                </div>
                            </div> : null }
                            {this.state.isActive && this.state.resetdatabaseclicked ?
                            <div class="level-item has-text-centered">
                            
                                <div className="field has-text-centered">
                                    <input
                                    type="submit"
                                    className="button is-info"
                                    onClick={this.populateDatabase}
                                    disabled={this.state.isButtonDisabled}
                                    value="Pre-Populate"
                                    />
                                </div>
                            </div> : null } 
                        </nav> 
                        {this.state.isSecure ?
                        <div class="block has-text-centered">
                        <strong>Database Reset: To insure database stability, the buttons will be disabled for 5 seconds</strong>.
                        </div> : null }
                        {this.state.isPopulating ?
                        <div class="block has-text-centered">
                        <strong>Populating Tables: To insure database stability, the buttons will be disabled for 5 seconds</strong>.
                        </div> : null }
                    </div>
                    </div>
                    </div>
                </div>
       );
    }
  }

export default AboutPage;
    