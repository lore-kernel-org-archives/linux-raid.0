From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Call for RAID-6 users
Date: Fri, 30 Jul 2004 15:58:34 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <cedr7a$s2$1@terminus.zytor.com>
References: <cds76e$ee7$1@terminus.zytor.com> <20040726213811.GA17363@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <20040726213811.GA17363@jim.sh>
By author:    Jim Paris <jim@jtan.com>
In newsgroup: linux.dev.raid
>
> > Thus, if you have used RAID-6 and have good or bad experiences, I'd
> > like to know them as soon as possible.
> 
> Just tried setting up a RAID-6 on a new server, and I'm seeing
> complete filesystem corruption.
> 
> I have 6 250GB disks, and want them all in the array.  I've created it
> degraded, with the first disk missing, since that disk temporarily
> holds the system.
> 
> Using kernel 2.6.7, mdadm 1.6.0, I did something like this:
> 
> # mdadm --create /dev/md1 --level=6 --chunk=128 --raid-devices=6 missing /dev/hd{g,i,k,m,o}2
> 
> which gives me:
> 
> md1 : active raid6 hdo2[5] hdm2[4] hdk2[3] hdi2[2] hdg2[1]
>       976269312 blocks level 6, 128k chunk, algorithm 2 [6/5] [_UUUUU]
> 

Okay, found the messages...

Can you create failures by creating a full array and then fail out
drives?  That would rule out problems with the way mdadm creates the
array.

**** When the array is just created, it's not synchronized!!! ****

Thus, when the array is first created it needs to finish synchronizing
before it's usable.  My current guess based on what I've seen so far
is that it's a bug in mdadm in creating arrays with exactly 1 missing
drive, as opposed to a kernel bug.

	-hpa
