From: "Donghui Wen" <dhwen@protegonetworks.com>
Subject: Re: RAID reconstruction problems
Date: Tue, 2 Sep 2003 11:29:16 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003d01c37180$1db2b730$df01010a@moon>
References: <87wucrnb63.fsf@cs.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Michael Duggan <md5i@sei.cmu.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have you partitioned the new disk before you rebuild?

Donghui

----- Original Message -----
From: "Michael Welsh Duggan" <md5i@cs.cmu.edu>
To: <linux-raid@vger.kernel.org>
Sent: Monday, September 01, 2003 8:04 PM
Subject: RAID reconstruction problems


> I currently have two small Software RAIDs, a RAID 1 for my root
> partition, and a RAID 5 for my usr partition.  One of the disks in the
> arrays died, and I threw in a new disk in with the intention of
> rebuilding the arrays.
>
> The rebuilds failed, but in an extremely strange fashion.  Monitoring
> /proc/mdstat, it seems that the rebuilds are going just fine.  When
> they finish however, /proc/mdstat includes the new disk, but also
> declares it invalid.  The system continues running in degraded mode.
>
> When I run this from the root console, I get some messages from the
> raid subsystem, including full debugging output.  I have not yet
> figured out how to capture this output in order to include in this
> message, but I did write down a part of one attempt (this was by hand,
> so there may be small inconsistancies):
>
> RAID5 conf printout
>  --- rd:3 wd:2 fd:1
>  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus0/target1/lun0/part3
>  disk 1, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
>  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host2/bus1/target0/lun0/part3
> md: bug in file raid5.c, line 1901
>
> Here is some output from my system.  If any more information would be
> useful, or anyone thinks I should try something else, please let me
> know.  I would like to get out of my currently degraded state!
>
>


----------------------------------------------------------------------------
----


>
> --
> Michael Welsh Duggan
> (md5i@cs.cmu.edu)
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Have you partitioned the new disk before you rebuild?

Donghui

----- Original Message -----
From: "Michael Welsh Duggan" <md5i@cs.cmu.edu>
To: <linux-raid@vger.kernel.org>
Sent: Monday, September 01, 2003 8:04 PM
Subject: RAID reconstruction problems


> I currently have two small Software RAIDs, a RAID 1 for my root
> partition, and a RAID 5 for my usr partition.  One of the disks in the
> arrays died, and I threw in a new disk in with the intention of
> rebuilding the arrays.
>
> The rebuilds failed, but in an extremely strange fashion.  Monitoring
> /proc/mdstat, it seems that the rebuilds are going just fine.  When
> they finish however, /proc/mdstat includes the new disk, but also
> declares it invalid.  The system continues running in degraded mode.
>
> When I run this from the root console, I get some messages from the
> raid subsystem, including full debugging output.  I have not yet
> figured out how to capture this output in order to include in this
> message, but I did write down a part of one attempt (this was by hand,
> so there may be small inconsistancies):
>
> RAID5 conf printout
>  --- rd:3 wd:2 fd:1
>  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus0/target1/lun0/part3
>  disk 1, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
>  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host2/bus1/target0/lun0/part3
> md: bug in file raid5.c, line 1901
>
> Here is some output from my system.  If any more information would be
> useful, or anyone thinks I should try something else, please let me
> know.  I would like to get out of my currently degraded state!
>
>


----------------------------------------------------------------------------
----


>
> --
> Michael Welsh Duggan
> (md5i@cs.cmu.edu)
>

