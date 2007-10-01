From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: problem killing raid 5
Date: Mon, 01 Oct 2007 22:47:17 +0400
Message-ID: <470140B5.3020203@msgid.tls.msk.ru>
References: <4700D454.7020607@gmail.com> <47013A6B.30302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47013A6B.30302@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Santos <daniel.dlds@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Santos wrote:
> I retried rebuilding the array once again from scratch, and this time
> checked the syslog messages. The reconstructions process is getting
> stuck at a disk block that it can't read. I double checked the block
> number by repeating the array creation, and did a bad block scan. No bad
> blocks were found. How could the md driver be stuck if the block is fine ?
> 
> Supposing that the disk has bad blocks, can I have a raid device on
> disks that have badblocks ? Each one of the disks is 400 GB.
> 
> Probably not a good idea because if a drive has bad blocks it probably
> will have more in the future. But anyway, can I ?
> The bad blocks would have to be known to the md driver.

Well, almost all modern drives can remap bad blocks (at least I know no
drive that can't).  Most of the time it happens on write - becaue if such
a bad block is found during read operation and the drive really can't
read the content of that block, it can't remap it either without losing
data.  From my expirience (about 20 years, many 100s of drives, mostly
(old) SCSI but (old) IDE too), it's pretty normal for a drive to develop
several bad blocks, especially during first year of usage.  Sometimes
however, number of bad blocks grows quite rapidly and such a drive
definietely should be replaced - at least Seagate drives are covered
by warranty in this case.

SCSI drives has 2 so-called "defect lists", stored somewhere inside the
drive - factory-preset list (bad blocks found during internal testing
when producing a drive), and grown list (bad blocks found by drive
during normal usage).  Factory-preset list can contain from 0 to about
1000 entries or even more (depending on the size too), grown list can
be as large as 500 blocks or more, whenever it's fatal or not depends
on whenever new bad blocks continues to be found or not.  We have
several drives which developed that many bad blocks in first few
months of usage, the list stopped growing, and they're still working
just fine for >5 years.  Both defect lists can be shown by scsitools
programs.

I don't know how one can see defect lists on a IDE or SATA drive.

Note that md layer (raid1, 4, 5, 6, 10 - but obviously not raid0 and
linear) are now able to repair bad blocks automatically, by forcing
write to the same place of the drive where a read error occured -
this usually forces drive to automatically reallocate that block
and continue.

But in any case, md should not stall - be it during reconstruction
or not.  For this, I can't comment - to me it smells like a bug
somewhere (md layer? error handling in driver? something else?)
which should be found and fixed.  And for this, some more details
are needed I guess -- kernel version is a start.

/mjt
