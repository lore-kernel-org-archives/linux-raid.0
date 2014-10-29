From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch checksum
Date: Wed, 29 Oct 2014 14:55:42 +0530
Message-ID: <CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
 <20141029200501.1f01269d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141029200501.1f01269d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Right on most counts but please see comments below.

On 29 October 2014 14:35, NeilBrown <neilb@suse.de> wrote:
> Just to be sure I understand, you would have N + X devices.  Each of the N
> devices contains an independent filesystem and could be accessed directly if
> needed.  Each of the X devices contains some codes so that if at most X
> devices in total died, you would still be able to recover all of the data.
> If more than X devices failed, you would still get complete data from the
> working devices.
>
> Every update would only write to the particular N device on which it is
> relevant, and  all of the X devices.  So N needs to be quite a bit bigger
> than X for the spin-down to be really worth it.
>
> Am I right so far?

Perfectly right so far. I typically have a N to X ratio of 4 (4
devices to 1 data) so spin down is totally worth it for data
protection but more on that below.

>
> For some reason the writes to X are delayed...  I don't really understand
> that part.

This delay is basically designed around archival devices which are
rarely read from and even more rarely written to. By delaying writes
on 2 criteria ( designated cache buffer filling up or preset time
duration from last write expiring) we can significantly reduce the
writes on the parity device. This assumes that we are ok to lose a
movie or two in case the parity disk is not totally up to date but are
more interested in device longevity.

>
> Sounds like multi-parity RAID6 with no parity rotation and
>   chunksize == devicesize
RAID6 would present us with a joint device and currently only allows
writes to that directly, yes? Any writes will be striped.
In any case would md raid allow the underlying device to be written to
directly? Also how would it know that the device has been written to
and hence parity has to be updated? What about the superblock which
the FS would not know about?

Also except for the delayed checksum writing part which would be
significant if one of the objectives is to reduce the amount of
writes. Can we delay that in the code currently for RAID6? I
understand the objective of RAID6 is to ensure data recovery and we
are looking at a compromise in this case.

If feasible, this can be an enhancement to MD RAID as well where N
devices are presented instead of a single joint device in case of
raid6 (maybe the multi part device can be individual disks?)

It will certainly solve my problem of where to store the metadata. I
was currently hoping to just store it as a configuration file to be
read by the initramfs since in this case worst case scenario the
checksum goes out of sync and is rebuilt from scratch.

>
> I wouldn't use device-mapper myself, but you are unlikely to get an entirely
> impartial opinion from me on that topic.

I haven't hacked around the kernel internals much so far so will have
to dig out that history. I will welcome any particular links/mail
threads I should look at for guidance (with both yours and opposing
points of view)
