From: Mike Hardy <mhardy@h3c.com>
Subject: Re: raidreconfig advice
Date: Sat, 12 Mar 2005 08:37:26 -0800
Message-ID: <42331AC6.6050109@h3c.com>
References: <4232B49C.6080306@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4232B49C.6080306@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: mwaterman@jingmei.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Max Waterman wrote:
> OK, I am going to try to expand the capacity of my raid5 array and I 
> want to make sure I've got it right.

Not a bad idea, as its all or nothing...

> Disk /dev/hdg: 200.0 GB, 200049647616 bytes
> Disk /dev/hdi: 200.0 GB, 200049647616 bytes
> Disk /dev/hdk: 200.0 GB, 200049647616 bytes
> Disk /dev/sda: 200.0 GB, 200049647616 bytes
> Disk /dev/sdb: 200.0 GB, 200049647616 bytes
> Disk /dev/sdc: 200.0 GB, 200049647616 bytes
> Disk /dev/sdd: 200.0 GB, 200049647616 bytes

They certainly all looked the same (including the C/H/S counts)

> This leaves me with sdc which I can try to add. If that goes OK, I'll 
> trash the backup and add sd[ab] too.

I'd be very wary of this, for two reasons. One, you have the backup 
during the add for a reason. If anything goes wrong, there goes your 
data. Second, where would you ever back your raid up to? What about fs 
corruption?

The rule of thumb with databases is to always have enough contiguous 
scratch space to dump and restore your biggest table. With large RAID, 
you should always be able to dump and restore your largest raid device, 
imho. Its a bunch more disk yes, but you'll need it at some point, I 
promise. Many future tears can be averted...

> 2) Where do I get raidreconfig from? Google wasn't much help.

I saw you noticed it raidreconf - you should be set there

> 3) Are there any instructions for raidreconfig? I understand is uses 
> some non-mdadm config files as from/to input.

the man page is great - honest. Two conf files (current and future) and 
you're set

The last question should be an open-ended "is there anything else"?

1) Run a long SMART test on all drives first. Imagine if you get a bad 
block during the reconfig...
2) Validate your backup (just in case)
3) ?? It takes a long time to do, be patient I guess
4) You could use the script I posted earlier that sets up a loopback 
device practice raid set to practice perhaps (if you really wanted)

Good luck-
-Mike
