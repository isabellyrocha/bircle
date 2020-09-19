<p align="center"><img src="https://github.com/isabellyrocha/bircle/blob/master/docs/slogan.png"/></p>


# Bircle: The Bottle Recycle Service

We are developing Bircle, a bottle recycling service which gives every individual the opportunity to contribute building green cities. Bircle takes from the end users the pain of recycling and streamlines the collected waste to material aggregators. 
According to a survey we performed, a person consumes at least one plastic bottle per day. From the end users perspective, due to their busy schedulers, the management of this waste becomes tiresome. On the other side of the spectrum, companies are interested in making their production more sustainable by including this waste into their process. Our proposed approach bridges this gap making it favorable to both parties. End users benefit from the replacement of traditional drop off stations with our convenient pick up service. On top of that, they also receive credit based on their contributions which motivates them to obtain or improve their recycling habits. Finally, construction industries can ultimately access the material needed for building eco friendly cities.

## Inspiration

First, we observe an increasing need for sustainable construction material such as plastic. On top of that, there is a lot of recycling potential wasted due to the complexity of the recycling process to the final user and industries. Oftentimes people don’t have the time or means to personally bring their plastic waste to the recycling facilities. More than that, in underdeveloped countries, the recycling process is not yet structured in a way that the user knows what to do with their trash. Considering all of that, we came up with an idea that  bridges the gap between companies in need for recycling materials and end users not knowing how or willing to take the effort of recycling. Our idea consists of a bottle recycle service where users can easily enter the recyclable bottles they have at home and request a pickup service which takes care of collecting and bringing them to the nearest qualified recycling facility.

## What it does

Bircle makes it easier for users to recycle their bottles. We make a bridge between recycling facilities and the consumer, increasing recycling rates and making the user’s life easier. The user can easily enter the bottles to be recycled by scanning their barcode. Once the user has collected enough bottles they can request the pickup service and that’s it! The pickup service is activated, which means the bottles will be picked up at the user’s place and dropped off at the nearest recycling facility.

## How we built it

Our initial prototype consists of an iOS app backed by a centralized data platform. The users can choose to register themselves by entering the required information manually or by connecting Bircle with their Google account.  The scanning feature is built on top of the Scandit API (inspired by the Migros supported tools). The scanning API gives us the scanned product’s EAN, or EAN13, stands for International Article Number (originally European Article Number). It is an extension of the UPC codes and you'll find them as barcodes on most everyday products.The EAN allows us to further search for and provide the user with more detailed information about the product. This step is done on top of EAN XML API (https://www.ean-search.org), which allows us to access information such as the name and category of the scanned products. The app provides the recycling historical data which we display in the form of a plot grouped by month. This graph is built using the open source front-end chart library Highcharts (https://www.highcharts.com). Finally, the app has a wallet with the financial information (e.g., gained credit due to recycling, current balance) and the user profile containing all the personal information (e.g., name, email, pickup address). Regarding data storage, we rely on the combination of Realm and MonoDB 4.4 which is currently synchronized with Atlas, running an A10 Tier Cluster on top of AWS.

## Challenges we ran into

One of the challenges we faced was regarding the categories from the EAN API. We expected the returned information about products to be more detailed, precise and consistent even between different brands. Our initial intentions with that was to better display the user’s products by categorizing them. However, as this was not the case, during the development we had to change the visualization and redesign what information to provide to the user. 
Moreover, both members of our team are backend engineers with little mobile development experience. This made the development of an iOS application in such a short period of time challenging for us. Finally, our background does not include UX skills which made the process of designing the application’s flow demanding.

## Accomplishments that  proud of

We are proud to get out of our comfort zone and push ourselves to the limits. As a result of that, we managed to gain skills that we didn’t have before and solved problems which we wouldn’t have been exposed to on our daily basis. All of this effort was backed by our motivation to work on a sustainable solution that has a greater purpose and impact from different perspectives.

## What I learned

Below we list our main takeaways from this experience.
- Waste management and recycling topic after so many years is a challenge which has many open questions. 
- Industries which consume plastics as their raw material to construct roads are willing to pay and contribute in a way to close the loop of waste management. 
- So many people still are not motivated to recycle their waste.

## What's next for Bircle

The current version of our application focuses on the end user spectrum of the problem. However, another application which will be used by companies or recycling facilities to receive the user requests is also necessary for this service to work. Therefore, our next main step would be developing a platform and application to cover this need.

When it comes to improving the current version of the developed application itself, we would like to further our prototype as well as expand it to other platforms (e.g., web, Android). Improvements in the current version would include a better design of our user interface and more robust functionality which involves an extensive planning and testing phase. Because we have already built the current version on top of MongDB, scaling it for more users would be a simple step as we can rely on its features to do so. However, a scalability testing phase would be required before expanding our horizon.

Finally, we would like to find partners which are willing to invest in your idea and launch a testing phase where we can evaluate all the positives and negatives aspects based and further refine this idea based on real user experience.
