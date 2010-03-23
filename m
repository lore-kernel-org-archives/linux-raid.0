From: Mark Knecht <markknecht@gmail.com>
Subject: 3-drive RAID1 for my low use home server?
Date: Tue, 23 Mar 2010 14:37:26 -0700
Message-ID: <5bdc1c8b1003231437q1cbeabex85833be0a59e3357@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   Just triple checking what I think I've learned here before I start
loading Gentoo. Parts are arriving and I'm staring to put them
together to build a combo low-use server (backups and MythTV) as well
as desktop for my wife. I can do anything up to 6 drives but want the
RAID to survive in the face of possibly two drive failure. This is all
low bandwidth stuff.

   I'm fairly focused at this point on doing RAID1 using 3 drives.
Unless I hear differently I believe a 3-drive RAID1 could survive 2
drive failures, and as well any single drive could be taken to another
machine or even placed in an external USB/eSATA drive container in the
event of some major motherboard failure. Is any of that incorrect?

   Also, along the way folks have mentioned hot spares but I'm not
seeing that a hot spare does much for RAID1. Am I incorrect about
that? Granted, I guess the rebuild starts automatically and maybe
that's worth it, but I'm thinking that mdadm can probably let me know
fairly quickly that I need to do some work. I've purchased 6 drives so
I'll have 2 or 3 spares around and I can do a hot spare but I don't
see the value in spinning the drive for a year burning power and
wearing the drive out vs. just putting it on the shelf and keeping it
in reserve for a rainy day.

   Off to start tearing into packaging. Thanks in advance again for
all the great info I've gotten so far.

Cheers,
Mark
