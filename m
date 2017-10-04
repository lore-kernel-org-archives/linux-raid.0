From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Wed, 4 Oct 2017 19:13:54 +0100
Message-ID: <db85eda5-5c5a-7d44-be51-d6c6ab7df2f2@youngman.org.uk>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <871sn78pzt.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
 <874ls0s7un.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
 <87lgkr3fgj.fsf@notabene.neil.brown.name> <20171004172819.GA3181@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171004172819.GA3181@lazy.lzy>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, NeilBrown <neilb@suse.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/10/17 18:28, Piergiorgio Sartor wrote:
> In order to conclude, please decide kernel vs.
> user space approaches*before*  making changes.
> 
> Thanks!
> 
>> Still... maybe it is a starting point for thinking about the problem.
> Yes, you're right,

Throwing a few ideas into the mix - shoot them down if they seem too 
outrageous :-)

1) Can we apply xattrs to devices in /dev?

2) Does xattrs lock out root?

Okay, this won't necessarily hide component devices, but if assembling 
an array (optionally) applies xattrs to them, and makes them writeable 
*only* by user "mdadm", then that will help prevent a load of damage. Of 
course, that doesn't protect a partition against be overwritten by a 
write to the underlying drive, but that's a whole 'nother can of worms...

And of course, the question is will this lock out the operations we 
don't want, while allowing stuff that we do ...

Provided xattrs does lock out root from user space, this looks to me to 
be the obvious route to try to go down, but what do I know?

Cheers,
Wol
