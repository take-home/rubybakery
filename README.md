# rubybakery

1. Bug: "no fillings" text is never displayed when cookies have no fillings
- strategy: manipulate cookies params to cover the edge case
  
2. Feature: Cookies should actually be cooked
   We lazily added to Cookie: def ready?; true; end
   But, the cookies are not actually ready instantly! When a cookie is placed in the oven, we need to trigger a background cooking worker to cook the cookies and update their state after a couple minutes of "cooking"
   - strategy: set an oven and keep track of it stage

3. Feature: As a bakery owner, I should see the oven page update automatically when the cookies are ready
   Given I have unfinished cookies in an oven
   And I am on the oven page
   Then I should see that the cookies are not yet ready
   When the cookies finish cooking
   Then I should see that the cookies are ready
   Note: Periodic polling is acceptable, but only the relevant part of the page should update
   - couldn't resolve this ticket, I think have something about the cooffee filles but not really sure how implement the react logic of cause update on state change on Ruby, really would like to understand better the aprouch 

4. Feature: As a bakery owner, I should be able to place a sheet with multiple cookies into an oven
   Given I have an oven
   When I am on the oven page
   Then I should be able to prepare a batch of cookies with the same filling
   When the batch of cookies is finished cooking
   Then I should be able to remove the cookies into my store inventory
   - strategy: substitute any from many and create a logic to account for more cookies. Also refactor tests to follow the logic.
   
5. Feature: As a bakery owner using the mobile web, I want my "Prepare Cookie" button to be first
   Since the Prepare Cookie button is really important, when the bakery owner is using a mobile screen, the prepare cookie button should be the first thing on the oven page. But, on non-mobile browsers, the button should remain where it is currently.
   - strategy: modificy css for smaller devices
