$MaximumFunctionCount = 8000
function Register-AWSCompleter {
	[scriptblock]$GetCompletions = {
		param($wordToComplete, $commandAst, $cursorPosition)
		$commandElements = $commandAst.CommandElements | ForEach-Object { $_.Extent.ToString() };
		$lastCommand = Get-LastCommand($commandAst.ToString());
		$commands = Get-Commands($commandAst.ToString());
		$script:cmdLn = @{
			Commands       = $commands;
			WordToComplete = $wordToComplete
		};
		if ($commands.Count -gt 2) {
			if ((Get-AvailableOptions($lastCommand)).Contains($cmdLn.Commands[2])) {
				$lastCommand = $lastCommand + "-" + $cmdLn.Commands[2];
			}
			$matches = (Get-AvailableOptions($lastCommand)).Where( { $_ -like "$wordToComplete*" });
			if ($matches.Count -gt 0) {
				return $matches |
				Where-Object { $_.StartsWith($wordToComplete) -and $_ -notin $commandElements } |
				ForEach-Object { $_ };
			}
		}
		else {
			[string[]]$result = Get-RootCompletionOptions;
			if ($wordToComplete -eq [string]::Empty -and $lastCommand -eq [string]::Empty) {
				return $result | ForEach-Object { $_ };
			}
			elseIf ($result.Contains($lastCommand)) {
				if ($commandAst.ToString().Length -eq $cursorPosition) {
					return $null;
				}
				$completions = Get-AvailableOptions($lastCommand) |
				Where-Object { $_ -notin $commandElements -and $_.StartsWith($wordToComplete) } |
				ForEach-Object { $_ };
				return $completions;
			}
			else {
				return $result |
				Where-Object { $_.StartsWith($wordToComplete) } |
				ForEach-Object { $_ };
			}
		}
	}
	$rootCommands = ('aws', 'aws.cmd');
	$aliases = (get-alias).Where( { $_.Definition -in $rootCommands }).Name;
	if ($aliases) { $rootCommands += $aliases }
	Register-ArgumentCompleter -CommandName $rootCommands -ScriptBlock $GetCompletions -Native
}
function Remove-CommandFlags($parameterName) {
	$cmd = $parameterName.Trim();
	$flags = Select-String '\s-{1,2}[\w-]*[=?|\s+]?[\w1-9_:/-]*' -InputObject $cmd -AllMatches;
	$flags.Matches.Value | ForEach-Object { $cmd = $cmd.Replace($_, " ") };
	return $cmd;
}
function Get-LastCommand($parameterName) {
	$cmd = Remove-CommandFlags($parameterName);
	$options = $cmd.Trim().Split(' ');
	if ($options.Count -lt 2) {
		return [string]::Empty;
	}
	return $options[1];
}
function Get-Commands($parameterName) {
	$cmd = Remove-CommandFlags($parameterName);
	$commands = $cmd.Split(' ') | Where-Object { $_ -ne [string]::Empty };
	return $commands;
}
function Get-RootCompletionOptions {
	$commands = (
		"accessanalyzer",
		"acm",
		"acm-pca",
		"alexaforbusiness",
		"amplify",
		"apigateway",
		"apigatewaymanagementapi",
		"apigatewayv2",
		"appconfig",
		"application-autoscaling",
		"application-insights",
		"appmesh",
		"appstream",
		"appsync",
		"athena",
		"autoscaling",
		"autoscaling-plans",
		"backup",
		"batch",
		"budgets",
		"ce",
		"chime",
		"cloud9",
		"clouddirectory",
		"cloudformation",
		"cloudfront",
		"cloudhsm",
		"cloudhsmv2",
		"cloudsearch",
		"cloudsearchdomain",
		"cloudtrail",
		"cloudwatch",
		"codebuild",
		"codecommit",
		"codeguru-reviewer",
		"codeguruprofiler",
		"codepipeline",
		"codestar",
		"codestar-connections",
		"codestar-notifications",
		"cognito-identity",
		"cognito-idp",
		"cognito-sync",
		"comprehend",
		"comprehendmedical",
		"compute-optimizer",
		"configservice",
		"configure",
		"connect",
		"connectparticipant",
		"cur",
		"dataexchange",
		"datapipeline",
		"datasync",
		"dax",
		"deploy",
		"detective",
		"devicefarm",
		"directconnect",
		"discovery",
		"dlm",
		"dms",
		"docdb",
		"ds",
		"dynamodb",
		"dynamodbstreams",
		"ebs",
		"ec2",
		"ec2-instance-connect",
		"ecr",
		"ecs",
		"efs",
		"eks",
		"elastic-inference",
		"elasticache",
		"elasticbeanstalk",
		"elastictranscoder",
		"elb",
		"elbv2",
		"emr",
		"es",
		"events",
		"firehose",
		"fms",
		"forecast",
		"forecastquery",
		"frauddetector",
		"fsx",
		"gamelift",
		"glacier",
		"globalaccelerator",
		"glue",
		"greengrass",
		"groundstation",
		"guardduty",
		"health",
		"history",
		"iam",
		"imagebuilder",
		"importexport",
		"inspector",
		"iot",
		"iot-data",
		"iot-jobs-data",
		"iot1click-devices",
		"iot1click-projects",
		"iotanalytics",
		"iotevents",
		"iotevents-data",
		"iotsecuretunneling",
		"iotsitewise",
		"iotthingsgraph",
		"kafka",
		"kendra",
		"kinesis",
		"kinesis-video-archived-media",
		"kinesis-video-media",
		"kinesis-video-signaling",
		"kinesisanalytics",
		"kinesisanalyticsv2",
		"kinesisvideo",
		"kms",
		"lakeformation",
		"lambda",
		"lex-models",
		"lex-runtime",
		"license-manager",
		"lightsail",
		"logs",
		"machinelearning",
		"macie",
		"managedblockchain",
		"marketplace-catalog",
		"marketplace-entitlement",
		"marketplacecommerceanalytics",
		"mediaconnect",
		"mediaconvert",
		"medialive",
		"mediapackage",
		"mediapackage-vod",
		"mediastore",
		"mediastore-data",
		"mediatailor",
		"meteringmarketplace",
		"mgh",
		"migrationhub-config",
		"mobile",
		"mq",
		"mturk",
		"neptune",
		"networkmanager",
		"opsworks",
		"opsworks-cm",
		"organizations",
		"outposts",
		"personalize",
		"personalize-events",
		"personalize-runtime",
		"pi",
		"pinpoint",
		"pinpoint-email",
		"pinpoint-sms-voice",
		"polly",
		"pricing",
		"qldb",
		"qldb-session",
		"quicksight",
		"ram",
		"rds",
		"rds-data",
		"redshift",
		"rekognition",
		"resource-groups",
		"resourcegroupstaggingapi",
		"robomaker",
		"route53",
		"route53domains",
		"route53resolver",
		"s3",
		"s3api",
		"s3control",
		"sagemaker",
		"sagemaker-a2i-runtime",
		"sagemaker-runtime",
		"savingsplans",
		"schemas",
		"sdb",
		"secretsmanager",
		"securityhub",
		"serverlessrepo",
		"service-quotas",
		"servicecatalog",
		"servicediscovery",
		"ses",
		"sesv2",
		"shield",
		"signer",
		"sms",
		"snowball",
		"sns",
		"sqs",
		"ssm",
		"sso",
		"sso-oidc",
		"stepfunctions",
		"storagegateway",
		"sts",
		"support",
		"swf",
		"synthetics",
		"textract",
		"transcribe",
		"transfer",
		"translate",
		"waf",
		"waf-regional",
		"wafv2",
		"workdocs",
		"worklink",
		"workmail",
		"workmailmessageflow",
		"workspaces",
		"xray");
	#$commands + $(Get-AWSCommonFlags);
	return $commands;
}
Export-ModuleMember Register-AWSCompleter;
Register-AWSCompleter