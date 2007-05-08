From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: "No such device" on --remove
Date: Tue, 08 May 2007 22:22:51 +0400
Message-ID: <4640BFFB.6030609@msgid.tls.msk.ru>
References: <20070508170441.GB4333@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070508170441.GB4333@scavenger.homeip.net>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Benjamin Schieder wrote:
> Hi list.
> 
> md2 : inactive hdh5[4](S) hdg5[1] hde5[3] hdf5[2]
>       11983872 blocks

> root@crazyhorse:~# mdadm -R /dev/md/2
> mdadm: failed to run array /dev/md/2: Input/output error
> root@crazyhorse:~# mdadm /dev/md/
> 0  1  2  3  4  5
> root@crazyhorse:~# mdadm /dev/md/2 -r /dev/hdh5
> mdadm: hot remove failed for /dev/hdh5: No such device
> 
> md1 and md2 are supposed to be raid5 arrays.

The arrays are inactive.  In this condition, an array can be
shut down, or bought up by adding another disk with proper
superblock.  So running it isn't possible because kernel thinks
the array is inconsistent, and removing isn't possible because
the array isn't running.

It's inactive because when mdadm tried to assemble it, it didn't
find enough devices with recent-enough event counter.  In other
words, the raid superblocks on the individual drives are inconsistent
(some are "older" than others).

If the problem is due to power failure, fixing the situation is
usually just a matter of adding -f (force) option to mdadm assemble
line, forcing mdadm to increment the "almost-recent" drive's event
counter before bringing the array up.

/mjt
