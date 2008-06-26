From: Mark Davies <mark@curly.ii.net>
Subject: Re: raid5 recovery dramas.
Date: Thu, 26 Jun 2008 22:25:51 +0800
Message-ID: <4863A6EF.5080908@curly.ii.net>
References: <48608E9B.6080904@curly.ii.net> <4863024A.4030909@curly.ii.net> <48639BDE.70001@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48639BDE.70001@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi David,

Thanks for your reply.  Good summary of events too.

>> the /dev/sde1 problem *may* be caused by lvm - try stopping that. However doing
>> this from an uptodate rescue CD sounds sensible.

I'm not running LVM - there's only one ext3 partition on that array.

Will try a live CD and see what that does.

So it's not overly critical if the LiveCD has a slightly different 
kernel version and version of mdadm?


Cheers,


Mark.
