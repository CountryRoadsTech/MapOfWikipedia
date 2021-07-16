// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
ActiveStorage.start()

// Include StimlusJS controllers.
import "controllers"

// Include all stylesheets.
import "../stylesheets/application.scss";

// Include d3.js data visualization library.
import * as d3 from "d3";
