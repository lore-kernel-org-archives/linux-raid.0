From: Mikulas Patocka <mpatocka@redhat.com>
Subject: change '%' to condition
Date: Wed, 11 Sep 2013 19:18:57 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1307201112210.2761@file01.intranet.prod.int.rdu2.redhat.com>
References: <1373890837-3475-1-git-send-email-Jes.Sorensen@redhat.com> <1373890837-3475-67-git-send-email-Jes.Sorensen@redhat.com> <alpine.LRH.2.02.1307151445220.23929@file01.intranet.prod.int.rdu2.redhat.com> <wrfjfvvely2a.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjfvvely2a.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, rhkernel-list@redhat.com
List-Id: linux-raid.ids

Hi

I think you should revert the patch 
4c0ca26bd260dddf3b9781758cb5e2df3f74d4a3 that did this change:

                for (f = 1; f < geo->far_copies; f++) {
                        d += geo->near_copies;
-                       if (d >= geo->raid_disks)
-                               d -= geo->raid_disks;
+                       d %= geo->raid_disks;
                        s += geo->stride;
                        r10bio->devs[slot].devnum = d;
                        r10bio->devs[slot].addr = s;


On most processors, the divide and modulo operations are slower than a 
possibly misprediteced branch or conditional move instruction.

So, replacing a condition with modulo doesn't make sense.

A benchmark on AMD K10 shows that mispredicted branch is 8.7 times faster 
than a divide operation:

        for (i = 0; i < 10000000; i++) {
                q++;
                if (q >= 8)
                        q -= 8;
        }
- 11607us (it compiles to cmov and runs at a rate of 3 ticks per 
iteration)

        for (i = 0; i < 10000000; i++) {
                q++;
                q %= max;
        }
- 101241us (26 ticks per iteration)


Mikulas
