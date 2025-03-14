## Release
1. 
2. ![[Screenshot 2025-03-11 at 18.17.37.png]]
	1. In your Jira task find the the Fix versions field.
		1. N.B if you the '+ Create new version' is not present, ask someone on your team to add you to the relevent jira group of your team
		2. The name of the fix version should correspond to the git tag version of your release
		3. ![[Screenshot 2025-03-11 at 18.20.25.png]]
		4. Select a start and end date for your release. This should be for when you want to deploy
		5. This will create a task on this release [board](https://checkout.atlassian.net/jira/software/c/projects/RELEASE/boards/122?assignee=5db6c0fd8704ba0dab23e23e&assignee=unassigned&assignee=712020%3A0f1be2c5-9b9b-4e90-9d75-2536f1306a27)
		6. ![[Screenshot 2025-03-11 at 18.27.25.png]]
			1. click on this ticket and find the details. You will need to select:
				1. Product Team: Card Processing
				2. Product Approver: ...
				3. QA Approver: Yourself
				4. Engineering Approver: 'Your engineering manager'
				5. Data impact: ...
			2. Move ticket to review
			3. Wait (nag) for approvals
			4. Once approved - move to Ready for Production
		7.  You should see a notification on https://checkout.enterprise.slack.com/archives/CEFCTS2N5
			1. ![[Screenshot 2025-03-12 at 13.35.06.png]]
			2. Confirm with the operations team that you can deploy at that time


## Deploy
1. Navigate to [Octopus](https://cp-octopus.mgmt.ckotech.co/) and find your project
	- ![[Screenshot 2025-03-12 at 13.38.35.png]]
2. Some services will have a blue/green deployment process. Others will have will not. Usually synchronous api's will require blue/green. Async API's won't
3. This is an example of a blue/green deployment. There are two channels here. The development channel can be used to deploy from development branches. The Release channel can be used for releases.
	1. ![[Screenshot 2025-03-12 at 13.41.43.png]]
4. You will required two people on a call for production deployment 
5. QA environments should be automatically deployed via github actions. The other enviroments will require manual deployment.
### Blue/Green deployment
- There are two types of blue/green 
	- First type is when all traffic is on either blue and green.
	- Second type is when the traffic is split on both blue and green
- Reduce all traffic to 0 in blue
- Check the logs that all traffic has been stopped
- Deploy all to blue
- Check the service in blue is running
	- This can be done by looking at health checks in the logs
	- Possible check that tcp connections have been established in the message bridges (Not sure if health checks will be successful tcp connections have not been established)
- Increase traffic to blue incrementally until 50 - e.g:
	- 0 -> 10
	- 10 -> 30
	- 30 -> 50
-  After each increment, check the service is working as expected
	- Accepting and responding to requests, etc...
- Reduce all traffic in green to 0 and blue to 100
- Repeat the previous steps until traffic is now 50/50

- There should be routing project in octopus for the project you are deploying https://cp-octopus.mgmt.ckotech.co/app#/Spaces-1/projects/dci-message-bridge-cko-eu-dual-routing/deployments?groupBy=Channel
	- This is a Load balancer where the traffic split is configured 
	- Click on project variables in the side
		- ![[Screenshot 2025-03-12 at 14.04.08.png]]
		- ![[Screenshot 2025-03-12 at 14.07.33.png]]
		- Save -> Create Release -> Deploy

## Logs
- `service:"DCI Message Bridge" env:prod pool:blue -@Properties.MessageType:(1814 OR 1804)`
	- Message type (MTI) of 1814/1804 is a health check. So this query can be used to check if dci message bridge in blue pool is receiving any messages which are not health checks. If no messages have been received, deployment in this environment is good to go
- Message Bridge: Possible that failures will occur when trying to reconnect
	- https://app.datadoghq.com/logs?query=service%3A%22DCI%20Message%20Bridge%22%20env%3Aprod%20pool%3Agreen%20connect&agg_m=count&agg_m_source=base&agg_q=%40Properties.BridgeAuthorizeRequest.DF47_13_CustomerIp&agg_q_source=base&agg_t=count&analyticsOptions=%5B%22bars%22%2C%22dog_classic%22%2Cnull%2Cnull%5D&cols=%40Properties.GatewayAuthorizeResponse.Approved%2C%40Properties.BridgeAuthorizeRequest.DF47_13_CustomerIp%2C%40Properties.BridgeAuthorizeRequest.DF47_2_CustomerEmail%2C%40Properties.BridgeAuthorizeRequest.DF63_5_CardMemberFirstName%2C%40Properties.BridgeAuthorizeRequest.DF63_6_CardMemberLastName%2C%40Properties.BridgeAuthorizeRequest.DF63_7_CardMemberBillingPhoneNumber%2C%40Properties.BridgeAuthorizeRequest.DF63_12_ShipToPhoneNumber%2C%40Properties.BridgeAuthorizeRequest.DF63_13_ShipToCountryCode%2C%40Properties.BridgeAuthorizeRequest.DF63_8_ShipToPostalCode%2C%40Properties.BridgeAuthorizeRequest.DF63_9_ShiptoAddress%2C%40Properties.GatewayAuthorizeResponse.SchemeTransactionId&event=AwAAAZWPBSj-Znh0yQAAABhBWldQQlNyeEFBQlI5MXJNLUJHUVhBQUMAAAAkMDE5NThmMGEtN2Y2Ny00YTljLWFiN2ItOTMxY2Y3OTg4MjkwAABxTQ&fromUser=true&messageDisplay=inline&refresh_mode=sliding&saved-view-id=1655584&storage=hot&stream_sort=pool%2Casc&top_n=10&top_o=top&viz=stream&x_missing=true&from_ts=1741257095108&to_ts=1741861895108&live=true
- Message Bridge: Once deployment is complete,  the service is connected to the schemes by checking if message bridge is 
- Message Bridge: Once a certain pool starts having traffic, check to see incoming and outgoing messages are being sent and received correctly. 
- Message Bridge: STAN (should be) unique for each request, you can check corresponding incoming and outgoing requests by checking the STAN
- Message Bridge: You can look at the MTI and check the schemes protocols to verify whether transactions have been correctly delivered 


### N.B
- You may not have access to create releases in Jira
- You may not have access to create deployments in Octopus
