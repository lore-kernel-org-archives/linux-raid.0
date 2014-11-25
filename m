From: "Boylan, Ross" <Ross.Boylan@ucsf.edu>
Subject: RE: homehost and 0.90 format
Date: Tue, 25 Nov 2014 03:31:32 +0000
Message-ID: <F1F13E14A610474196571953929C02096432BD@ex08.net.ucsf.edu>
References: <F1F13E14A610474196571953929C020963C639@ex08.net.ucsf.edu>,<20141125140821.6ece0afb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141125140821.6ece0afb@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks; I didn't know one could do that.

But am I correct in my understanding that if 2 arrays have the same homehost they will have the same end (last half?) of the UUID?  That would mean the 2 devices I'm looking at can't have the same homehost.

I am able to guess the homehost for one of them using your trick; none of the possibilities have tried have matched the other.

Ross
________________________________________
From: NeilBrown [neilb@suse.de]
Sent: Monday, November 24, 2014 7:08 PM
To: Boylan, Ross
Cc: linux-raid@vger.kernel.org
Subject: Re: homehost and 0.90 format

On Tue, 11 Nov 2014 03:14:34 +0000 "Boylan, Ross" <Ross.Boylan@ucsf.edu>
wrote:

> I am trying to figure out which of my RAID devices is considered home.  I haven't switched machines, but I have several operating systems, with different hostnames, on the machine.  0.90 format metadata.
>
> Even 2 RAID devices created on the same OS don't seem to have any UUID in common.  i thought that the end of the UUID's would be the same.  For example, inhttp://marc.info/?l=linux-raid&m=123999237229707 Neil Brown says
> > Note that 0.90 metadata does contain homehost information to some
> > extent.  When homehost is set, the last few bytes of the uuid is set
> > from a hash of the homehost name.  That makes it possible to test if a
> > 0.90 array was created for 'this' host, but not to find out what host
> > it was created for.
>
> mdadm.conf has
> HOMEHOST <system>
>
> The 2 UUIDS are
>  8691ad98:af955756:ae5efbfa:dfd20ce6
> 6d89d3b5:19a0acce:319e1a9c:58606385
>
> Thanks,
> Ross Boylan

You need to guess-and-test.
e.g.

  mdadm --detail /dev/md7 --homehost=foo | grep UUID

If it says "(local to host foo)", then "foo" is the correct name.
If not, then try a different name.

NeilBrown


>
> Details:
>
> root@wheezy4:~# mdadm --detail /dev/md7
> /dev/md7:
>         Version : 0.90
>   Creation Time : Fri Oct  3 17:20:13 2014
>      Raid Level : raid1
>      Array Size : 48828352 (46.57 GiB 50.00 GB)
>   Used Dev Size : 48828352 (46.57 GiB 50.00 GB)
>    Raid Devices : 1
>   Total Devices : 1
> Preferred Minor : 7
>     Persistence : Superblock is persistent
>
>     Update Time : Tue Nov  4 17:48:40 2014
>           State : clean
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>
>            UUID : 8691ad98:af955756:ae5efbfa:dfd20ce6
>          Events : 0.1
>
>     Number   Major   Minor   RaidDevice State
>        0       8       20        0      active sync   /dev/sdb4
> root@wheezy4:~# mdadm --detail /dev/md8
> /dev/md8:
>         Version : 0.90
>   Creation Time : Tue Sep 30 13:27:56 2014
>      Raid Level : raid1
>      Array Size : 970702784 (925.73 GiB 994.00 GB)
>   Used Dev Size : 970702784 (925.73 GiB 994.00 GB)
>    Raid Devices : 2
>   Total Devices : 1
> Preferred Minor : 8
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Nov 10 18:16:11 2014
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>
>            UUID : 6d89d3b5:19a0acce:319e1a9c:58606385
>          Events : 0.790792
>
>     Number   Major   Minor   RaidDevice State
>        0       8       19        0      active sync   /dev/sdb3
>        1       0        0        1      removed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

