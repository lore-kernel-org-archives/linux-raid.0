From: Bill Welch <bill@brazier.com>
Subject: HOWTO: mark spare drive as active without reconstruct
Date: Fri, 05 Sep 2003 23:16:30 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309052156380.23336-100000@viridine.brazier.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a drive marked as spare that I know is a synced member of a raid5.  
I want to add it back into the array *without* a reconstruct, i.e. just
mark it as active and change it's position.

How do I do that? Force assembly seems to just change the update time and
mark as active, but I don't know what it will do about the position. On
the other hand, hot add would change the postion of the drive, but, I
expect, launch a reconstruct I don't want.

Background:

I had a 'soft' error on one drive of a four drive raid5. I know now that I
could have forced the assembly, but at the time chose to raidhotadd the
existing drive. At the end of the reconstruct, /proc/mdstat presented me
with a two drive failure! One of the other drives now had an earlier
update time and was marked dirty, no-errors, seemed to be fine otherwise.
The drive that reconstructed was up to date, but was marked spare and 
therfore no longer in the array.

The first step I took to recover was to force the assembly with three 
drives - all but the drive marked spare. That seemed to work fine and I 
can mount the array. Now, of course the spare is out of date, but also out 
of position.

redhat 9, mdadm 1.3, a raidtab, and no mdadm.conf

Bill.



