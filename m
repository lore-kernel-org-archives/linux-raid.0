From: "Peter W. Morreale" <morreale@sgi.com>
Subject: some general md raid questions
Date: Wed, 12 Oct 2011 08:47:05 -0600
Message-ID: <1318430825.6598.68.camel@hermosa.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all,

I have a couple of md RAID questions related to larger numbers of disks.
Some may seem a little naive, but please bear with me.  Thanks in
advance for any information...

First off, are there any architectural docs describing the current
software implementation?  I can find lots on *using*...   I am starting
to dive into the code, just wondering whether there is a 5000ft view I
can start from...

Assuming I have two or more jbods attached to the machine, how can I
determine which disks are associated with which paths?  (Yes, sorry, I
realize this is a general discovery question and not specific to
raid :-)

Will 'data' and 'parity' datum span more than one disk within the
layout?  Assume I have 8 disks for a raid6, with the default
left-symmetric-6 layout.  Do I get a layout of data1-1, data1-2, p1-1,
p1-2, data2-1, data2-2, p2-1, p2-2?  Or data1-1, data1-2, data2-1,
data2-2, p1-1, p1-2, p2-2, p2-2? (or maybe I misinterpreted
left-symmetric-6)?

Rebuilding appears to performed by a workqueue.   Is that right?  Can I
set affinity/class/priority on workqueues?  (sorry, general kernel
question, I know.  But thanks anyway)  Would there be objection to an md
'feature' to segregate rebuilding tasks to specific CPUs for smp boxen?
if this doesn't exist in some form already?

Is there an upper limit on speed_limit_{max,min}?   This is merely a
bandwidth, throttling control, correct?  This 'speed limit' is related
to the write speed of the disks, right?  If so, what happens in the case
of mis-matched disks?  (say SSDs, and 7200rpm and 5400rpm disks)  I'm
not suggesting this, I just want to make sure I understand the effects
here...

Is it possible to change (and have them recognized) the speed limits
*during* the rebuild process?

Assuming a 8 disk, raid6 array again...   When one of the disks is in a
raid6 group is rebuilding, will incoming stripes be routed to the
consistent raid6 group?  or will they continue to access the raid6 group
with the rebuilding disk until that group is 'full'?

I'm trying to plan for a raid system where a disk failure is a normal
(and likely) course of events, so layout and control of the rebuild
process is fairly important.  If there are other thoughts regarding
same, please share with me.

Greatly appreciate your time.

Best Regards,
-PWM






