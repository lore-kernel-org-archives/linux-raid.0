From: Andy Dawson <A.J.Dawson@Bradford.ac.uk>
Subject: Re: Software RAID1 problems
Date: Fri, 23 Sep 2005 16:45:34 +0100 (GMT Standard Time)
Message-ID: <Pine.WNT.4.63.0509231622040.2312@ender>
References: <17189.65525.274983.671124@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17189.65525.274983.671124@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After a fairly long time without seeing the following message:

"This is an automatically generated mail message from mdadm
running on servername

A DegradedArray event had been detected on md device /dev/md0.

Faithfully yours, etc."

It reared its head again today.

I've checked dmesg and /var/log/messages and the only thing I've found so 
far is the following in dmesg:

md: considering sda1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: running: <sda1>
raid1: raid set md0 active with 1 out of 2 mirrors

md1 works fine and md sets md1 active with 2 out of 2 mirrors.

/dev/sdb2 is the device that appears to be causing the problem, so can 
anyone tell me what might be happening?  Any ideas why it might not be 
included in the array at boot time? (I've tried Google but found no 
answers yet).

Any help would be appreciated!

Regards
Andy



On Tue, 13 Sep 2005, Neil Brown wrote:

> On Monday September 12, A.J.Dawson@Bradford.ac.uk wrote:
>>
>> Has anyone any idea what might be causing the degradedarray event to
>> occur?
>
> What kernel messages do you get when it happens (in /var/log/kern.log
> on wherever your distro puts them)?
>
> NeilBrown
>

Dr. Andy Dawson
A.J.Dawson@Bradford.ac.uk
http://www.mossie.org
http://www.museum-explorer.org.uk

  Never attribute to malice that which can adequately be explained by stupidity
