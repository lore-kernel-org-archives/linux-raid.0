From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: What are mdadm maintainers to do? (error recovery redundancy/data
 loss)
Date: Tue, 17 Feb 2015 09:48:07 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1502170940010.4007@uplift.swm.pp.se>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org> <54E1EDEA.1030503@turmel.org> <loom.20150216T165111-551@post.gmane.org> <54E226B5.1080500@turmel.org>
 <loom.20150216T183419-387@post.gmane.org> <20150217104906.62d36c62@notabene.brown> <loom.20150217T080345-764@post.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20150217T080345-764@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris <email.bug@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 Feb 2015, Chris wrote:

> Evererybody please answer with improved versions if you can.
>
> if smartctl tool is available
>  if scterc is disabled
>    /usr/sbin/smartctl -l scterc,70,70 ${DEVNAME}
>  else
>    if screrc is not available
>      echo 180 >/sys/block/${DEVNAME}/device/timeout
>
> Found an older implementation that "seems to work fine":

Hi,

Generally I like this idea, and I agree that this would be a good idea, 
but if I was running raid0 or linear, I might not want scterc to be 
enabled.

Also, what would the harm be to always bump the timeout to 180 seconds? 
Yes, drives would take longer to be kicked out in case of errors, but if 
we're confident in scterc working, wouldn't we want to turn down the 
timeout to 10-15 seconds then?

Personally I turn on scterc if available and turn up the timeout to 180 
seconds, always, regardless what drives I'm running. I'd rather wait 
longer for a drive to be considered dead, than to have drives being kicked 
due to some hiccup in the system (controller or drive reset) that might 
rectify itself.

So I would suggest turning on scterc and turning up the timeout to 180 
seconds as soon as mdadm is installed. This is the best tradeoff I can 
come up with between stability and fast drive-dead-detection time.

Here on the list I see people all the time coming in with multiple drives 
kicked due to controller resets and other intermittent flukes, I never see 
people coming in complaining that it took 30 seconds to detect a drive 
error. I doubt there'd be much complaint for 180 seconds. If someone needs 
faster detect times then my opinion is that they are in the category who 
can be expected to tune this value to their application. 180 seconds works 
best for the "larger crowd" using mdadm.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
