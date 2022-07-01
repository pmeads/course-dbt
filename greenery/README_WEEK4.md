### How are our users moving through the product funnel?

My first pass at answering this question was to check out the events table. I used my fct_events model for this. 
I then created a intermediate model where i did the following work
- collected the distinct sessions
- of the distinct session, discovered which sessions had an add to cart event and which sessions had a checkout event
- created a table of each session with a page view event, a add_to_cart event (or not), a checkout event (or not)
Using this int model, I created a customer funnel model that aggregated the different events, and then ran conversion rates on the results

|                     	    | page_view	| add_to_cart	| checkouts	| updated_at |
| ------------------------- | --------- | -----------   | --------- | ---------- |
| Count	                    | 578	    | 467	        | 361	    | 2022-07-01T00:46:43.6Z |
| Session Conversion Rate	| 1.00	    | 0.81	        | 0.62	    | 2022-07-01T00:46:43.6Z |
| Checkout Conversion Rate*	| 0	        | 0	            | 0.77	    | 2022-07-01T00:46:43.6Z |
\* what % of added to cart also had checkout


### Which steps in the funnel have largest drop off points?

If I did this right, it looks like for Greenery, there is more of a customer drop off (23%) between add_to_cart and checkout than page_view to add_to_cart (19%). 
