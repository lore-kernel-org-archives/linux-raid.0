From: Gordon Henderson <gordon@drogon.net>
Subject: Re: now on to tuning....
Date: Wed, 9 Mar 2005 09:46:01 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0503090926190.4055@lion.drogon.net>
References: <6F9171BE257CA742BFBCFA87B8F20F8D030E4351@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <6F9171BE257CA742BFBCFA87B8F20F8D030E4351@NZURC900PEX1.ubsgs.ubsgroup.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 9 Mar 2005 peter.greis@ubs.com wrote:

> Greetings All,
>
> I have been lurking for a while.... I recently put together a raid 5
> system (Asus K8NE SIL 3114/2.6.8.1 kernel) with 4 300GB SATA Seagate
> drives (a lot smaller than the bulk of what seems to be on this list!).

Size isn't important :)

> Currently this is used for video and mp3 storage, being Reiser on LVM2.
>
> So a couple of questions:
>
> Bonnie++ to test, but with which parameters ? Also, I have seen the
> mount option "nolargeio=1" for reiser, but not a lot of information on
> the impact in raid systems.
>
> Any thoughts ?

Why LVM2? Are you taking snapshots, or expecting to re-size the array?

I just could never work out why I needed yet another layer of software
between the application and the disk platter. There may well by a good
reason for it - I did look into LVM some 18 months ago when I was looking
at snapshot solutions though, but it was hideously slow (or appeared to
be) after I'd taken a snapshot. (My intention was to tape dump from the
snapshots, and provide a 'yesterday' & 'the day before' type things. I now
use rsync for that - takes time to make the snapshot, but accesses to it
are no slower than accessing the live aray.

I know nothing about reiser either, so can't help there, I'm afraid,
however, XFS has some real-time facilities which might be useful for
streaming data, but again, it's not something I've looked into.

Anyway - if you are streaming big files, you want nothing more than time
dd to test the speed of the thing. Bonnie++ will limit the size of a
single file to 2GB (and write multiple 2GB files if you specify a bigger
size) and you'll get an indication of how busy the CPU is when it's
writing & reading. Your drive will have between 55 and 65MB/sec of head
bandwidth, so anything better than that is a bonus, athough the 3114 will
have all 4 ports on the same PCI bus, so thats going to be your
bottleneck.

If you want more speed, you might want to try to reconfigure it in a
RAID-10 way, but then you'll only get 2 disks worth of storage rather than
the 3 in a RAID-5 setup.

Also test streaming over LAN if thats what you are doing - if it's just a
100Mb LAN, then all your disk system needs to be able to do is 12MB/ses
and anything more is a bonus.

And do check your disks regularly, although I don't think current version
of smartmontools fully supports sata under the scsi subsystem yet...

Good luck,

Gordon
