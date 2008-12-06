From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: time limited error recovery and md raid
Date: Fri, 05 Dec 2008 18:42:33 -0600
Message-ID: <4939CA79.8050009@gmail.com>
References: <1228510646.16555.73.camel@localhost>  <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan> <1228518288.16555.98.camel@localhost> <alpine.DEB.1.10.0812051851010.4906@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812051851010.4906@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Redeeman <redeeman@metanurb.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 
> 
>> On further thought, might this not suggest that the linux raid system
>> waits indefinetly for I/O error, before kicking out?
> It times out after 1-2 minutes.  I have been dealing with this for a 
> very long
> time, another 'symptom' is short smart tests taking forever when the 
> disk is in a soon-to-be failing state.
>>
>> If that is indeed the case, then if the use of the raid isnt
>> time-critical, then maybe its a good thing to have tler enabled, just in
>> case the disk is able to fix stuff?
> With TLER enabled the drive is kicked out immediately. The purpose of 
> TLER is
> that of HW raid where it can alert the controller about it and the 
> controller
> handles it.

Without TLER typically the raid controller will eventually (after 30 
seconds or so) declare the disk dead and go on about its business.

The only thing TLER saves you is the 23 second faster timeout before 
the disk is declared dead.   And if you are doing something critical 
the 7 second timeout is still potentially very troublesome.    I would 
have though TLER had more value to be set quite a bit lower than 7 
seconds.
