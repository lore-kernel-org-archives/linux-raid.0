From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: device and partition alignment
Date: Sat, 05 Jun 2010 23:51:32 +0200
Message-ID: <4C0AC6E4.4080408@stud.tu-ilmenau.de>
References: <000b01cb04f0$dbcf7720$936e6560$@woodlea.com>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000b01cb04f0$dbcf7720$936e6560$@woodlea.com>
Sender: linux-raid-owner@vger.kernel.org
To: Graham Mitchell <gmitch@woodlea.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Graham,

I guess you couldn't find much about this as it has more to do with
common sense than magic formulae.  If you have 4k-sector drives, align
everything at multiples of 4k, use filesystem-units of multiples of 4k.
 As I read and it also seems very logical from the ATA / SCSI point of
view, a stripe size of 256k seems most straight forward.  This is the
largest amount of data (a.t.m.) that can be read or written with a
single command to a disk.

What should I say more?  Well, block 63 is too oldschool, coming from
the CHS-alignment of old disks.  It doesn't make any sense nowadays.

My suggestion:
- use GPT partitioning (for safeness into the future)
- align the first partition at block 64
- use a filesystem chunk size of at least 4k (depending on the data you
want to store you might use even larger chunks)

Hope it helps,
Stefan

Am 05.06.2010 22:51, schrieb Graham Mitchell:
> I've spent the last couple of days doing some googling, and my goodle-fu
> seems to have deserted me at the moment.
> 
> I'm looking for some guides and/or words of wisdom on how to partition disks
> with optimal alignment for RAID devices, and also the same for laying file
> systems on those devices. I've just (re)created a 15 drive RAID 6 array, and
> I've partitioned the disk, and I'm building the array on partition 1, which
> I see starts at block 63 - I am guessing that this is non-optimal? Is there
> a magic formula that can be used to work out what the optimal starting block
> on the disk should be, so that we can avoid (or at least reduce) the
> read/modify/write penalty on the physical drives?
> 
> Is there also a magic formula for doing the same for file systems laid down
> on a RAID device? I guess that this would depend on the type of superblock
> used, since there seems to be different locations (start, end, start +4k)
> for it. 
> 
> I've read thru the manual pages (shocking I know), and I can't see anything
> mentioned in there, and there's certainly no --optimal-alignment option
> there (any chance for next version - lol).
> 
> Can someone point me in the direction of some reading about this please?
> 
> Thanks.
> 
> 
> Graham
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

