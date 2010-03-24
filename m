From: Eric Shubert <ejs@shubes.net>
Subject: Re: 3-drive RAID1 for my low use home server?
Date: Wed, 24 Mar 2010 07:49:19 -0700
Message-ID: <hod8pf$imk$1@dough.gmane.org>
References: <5bdc1c8b1003231437q1cbeabex85833be0a59e3357@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003231437q1cbeabex85833be0a59e3357@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Knecht wrote:
> Hi,
>    Just triple checking what I think I've learned here before I start
> loading Gentoo. Parts are arriving and I'm staring to put them
> together to build a combo low-use server (backups and MythTV) as well
> as desktop for my wife. I can do anything up to 6 drives but want the
> RAID to survive in the face of possibly two drive failure. This is all
> low bandwidth stuff.
> 
>    I'm fairly focused at this point on doing RAID1 using 3 drives.
> Unless I hear differently I believe a 3-drive RAID1 could survive 2
> drive failures, and as well any single drive could be taken to another
> machine or even placed in an external USB/eSATA drive container in the
> event of some major motherboard failure. Is any of that incorrect?

All sounds right to me. Just be sure that the array is defined with 3 
drives and no spares.

>    Also, along the way folks have mentioned hot spares but I'm not
> seeing that a hot spare does much for RAID1. Am I incorrect about
> that?

Right. The only thing it would buy you is a little write performance, 
but you'd lose a little read performance, and take a performance hit 
if/when one drive goes off.

> Granted, I guess the rebuild starts automatically and maybe
> that's worth it, but I'm thinking that mdadm can probably let me know
> fairly quickly that I need to do some work. I've purchased 6 drives so
> I'll have 2 or 3 spares around and I can do a hot spare but I don't
> see the value in spinning the drive for a year burning power and
> wearing the drive out vs. just putting it on the shelf and keeping it
> in reserve for a rainy day.

Just one thought here. There is a certain "infant mortality syndrome" 
that drives experience (according to google study). I would rotate 
drives from the shelf into service after a year or so, while they're 
still under warranty (assuming 3yr warranty). If the warranty period is 
less than 2yr, rotate them sooner.

NJoy!

-- 
-Eric 'shubes'

