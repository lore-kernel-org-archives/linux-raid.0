From: klink@clouddancer.com (Colonel)
Subject: (unknown)
Date: Tue,  4 Jun 2002 18:54:52 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020605015452.70D1D8347@phoenix.clouddancer.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, pegasus@telemach.net
List-Id: linux-raid.ids

From: Colonel <klink@clouddancer.com>
To: pegasus@telemach.net
CC: linux-raid@vger.kernel.org
In-reply-to: <20020604235518.2cb7d7d7.pegasus@telemach.net> (message from Jure
	Pecar on Tue, 4 Jun 2002 23:55:18 +0200)
Subject: Re: 
Reply-to: klink@clouddancer.com
References: <20020604154712.AD48D8347@phoenix.clouddancer.com> <20020604235518.2cb7d7d7.pegasus@telemach.net>

   Date: Tue, 4 Jun 2002 23:55:18 +0200
   From: Jure Pecar <pegasus@telemach.net>

   On Tue,  4 Jun 2002 08:47:12 -0700 (PDT)
   klink@clouddancer.com (Colonel) wrote:

   > 
   > True, I think that the point is that of the 5 possible 2 disk
   > failures, 2 of them (in striped mirrors, not mirrored stripes) kill
   > the array.  For RAID5, all of them kill the array.  But the fancy RAID
   > setups are for _large_ arrays, not 4 disks, unless you are after the
   > small write speed improvement (as I am).

   going offtopic here ...
   what kind of raid setup is the best for write intensive load like mail
   queues & co?

define "best"

For sequential writes, RAID10 is considered 'best'.

However, there are two ways to make "10", one has far better reliability
-- which is best for some configurations, the striped mirrors.

YMMV

To truely answer your question requires knowing how many drives,
detailed load and bandwidth info, economics and politics.



   > Plus any raid metadevice made of metadevices cannot autostart, which
   > means tinkering during startup, which is only worth it for those large
   > drive arrays.

   hm? it does for me. probalby the redhat's rc.sysinit does the right
   thing ... 


If you can run one on / (the root partition), then it autostarted.  If
it's on /usr, then it was manually started (if it's striped mirrors)
to my knowledge.  On the other hand, you may have mirrored stripes --
which potentially do autostart (I vaguely remember this discussion
many moons ago, when M.Ingo was introducing the current raid, but I
wanted raid 5 ...).

For myself, I grew disatisfied with the disk usage in RAID5. All drive
'lights' were on too often.  Now, it's quieter, slightly faster, less
blinky lights and smaller.
