From: Phil Turmel <philip@turmel.org>
Subject: Re: Help Reassembling a raid5 array
Date: Tue, 8 Dec 2015 14:48:14 -0500
Message-ID: <566733FE.9000906@turmel.org>
References: <CAJGWEk93QAmCdik4_rxGPcq7dm=2tXX1U19Zkn5OwcAog0Z-RA@mail.gmail.com>
 <56665129.6050404@turmel.org>
 <CAJGWEk-UovYPJcyCOhUNO4XahraB_9E5QriObJe+S6uVT_Rs1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJGWEk-UovYPJcyCOhUNO4XahraB_9E5QriObJe+S6uVT_Rs1g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Wilkins <andrew.m.wilkins@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Andrew,

{Added the list back.  Convention on kernel.org is reply-to-all, trim
replies, and either interleave your reply or bottom post.  I've left
some context untrimmed for the list to see.}

On 12/08/2015 01:03 PM, Andrew Wilkins wrote:
> Hi Again
> Thanks for your help
> 
> I had tried exactly what you suggested several times and it did not
> work which is why i thought i was out of options. It had been loaded
> had loaded from an ubuntu 15.10 disk for recovery
> A colleague loaded a purpose build rescue disk from here
> http://www.sysresccd.org/SystemRescueCd_Homepage
> and the same thing worked, unfortunately i don't have any more details
> on what version it was, but i assume the latest

Does this mean you did or did not use system rescue CD for this incident?

> the only difference between our commands was i used /dev/md/0 and my
> colleague used /dev/md0
> but the difference i assume is just to do with where the different
> distros mount arrays, the extra / was something ubuntu was able to put
> in all by it's self when running --scan

Correct. The difference between /dev/md0 and /dev/md/0 is not relevant.

> this is what i was trying in ubuntu and the output
> 
> root@ubuntu:/home/ubuntu# mdadm --assemble --force /dev/md/0 /dev/sdb1
> /dev/sdd1 /dev/sde1 /dev/sdf1 -v
> mdadm: looking for devices for /dev/md/0
> mdadm: /dev/sdb1 is identified as a member of /dev/md/0, slot 0.
> mdadm: /dev/sdd1 is identified as a member of /dev/md/0, slot 2.
> mdadm: /dev/sde1 is identified as a member of /dev/md/0, slot 3.
> mdadm: /dev/sdf1 is identified as a member of /dev/md/0, slot 4.
> mdadm: no uptodate device for slot 2 of /dev/md/0
> mdadm: added /dev/sdd1 to /dev/md/0 as 2
> mdadm: added /dev/sde1 to /dev/md/0 as 3
> mdadm: added /dev/sdf1 to /dev/md/0 as 4 (possibly out of date)
> mdadm: added /dev/sdb1 to /dev/md/0 as 0
> mdadm: /dev/md/0 assembled from 3 drives - not enough to start the array.
> 
> 
> It's like --force made no difference, does this seem like a bug for it
> to work on this array on one distro but not the other ? or will it be
> down to differences in versions and/or how they are setup

There are differences.  There have been bugs with --force in the past.
That's why I requested you use a recent liveCD.  New kernel and new
mdadm.  Also, try putting --force twice.

Phil
