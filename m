From: Jean de Largentaye <jean@largentaye.org>
Subject: Aliens ate my superblock!
Date: Fri, 24 Dec 2010 18:44:57 +0100
Message-ID: <AANLkTimzJEdHDgnKbA5rk1Jwf7471Tib-JW3akEuWbwE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks,

I have a case where I lost the last ~2000 sectors of my hard drives*.
As that's where the 0.90 superblock is stored, those disks are no
longer automatically recognized by md. Apart from that part, my disks
and other hardware is fine.

This is a RAID6 with 6 disks, 3 of which were chomped, so my RAID is
at this point failed. However, I'm the kind of embedded engineer who
likes to program with live wires and magnetic tape, so I figure I can
try and reconstruct that data, possibly by copying and altering the
superblocks from the other disks.

My google-fu may be weak, but I haven't found any info on the wiki or
on the ML about on-disk structures and recovering from this kind of
nightmare scenario. I haven't yet opened up the source (kernel or
mdadm). So my questions are:

Has anybody else faced and recovered from such a situation? Apart from
the superblock, is there any metadata I have to worry about in the
last 1MB of space on the disk? This may not be the best place to ask,
but is there any XFS data around there which I have to worry about as
well?

I can give much more details of course. And, oh yeah, merry Festivus ;)

John

*I'm going to name names: the consumer motherboard Gigabyte GA-P35-DS4
has a feature/bug where it backs up the BIOS at the end of the first
hard disk, hiding that part using Host Protected Area. By the time I
understood what was going on, I had already had 3 disks chomped from
swapping them on the controller.
