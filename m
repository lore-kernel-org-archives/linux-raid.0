From: Mike Hardy <mhardy@h3c.com>
Subject: Re: RAID over Firewire
Date: Wed, 23 Aug 2006 14:34:05 -0700
Message-ID: <44ECC9CD.7020502@h3c.com>
References: <44EB94BE.8080907@sauce.co.nz> <200608231510.26160.Dexter.Filmore@gmx.de> <44ECC870.2090202@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44ECC870.2090202@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Richard Scobie wrote:
> Dexter Filmore wrote:
> 
>> Of all modes I wouldn't use a linear setup for backups. One disk dies
>> - all data is lost.
> 
>> I'd go for an external raid5 solution, tho those tend to be slow and
>> expensive.
>>
> 
> Unfortunately "budget" is the overriding factor here. Unlike RAID 0, I
> thought there may be a way of recovering data from undamaged disks in a
> linear array, although I guess the file system used has some say in this.
> 
> I hope to mitgate the risk somewhat by regularly using smartd to do long
> self tests on the disks.


Long self tests will just tell you that you lost a block before RAID or
the FS notices it, it's not going to stop the block (and your data) from
going away.

One more disk and you have raid 5 at least with the same storage
capacity. md will transparently (to the OS, you'll get a log message)
recover from single block errors in raid5.

I'm not sure SMART works over firewire anyway. That's a question.

http://smartmontools.sourceforge.net/:

"As for USB and FireWire (ieee1394) disks and tape drives, the news is
not good. They appear to Linux as SCSI devices but their implementations
do not usually support those SCSI commands needed by smartmontools."

Note that page is slightly out of date - they mention SMART for SATA is
supported through a patch to mainline, but it is in fact mainline now.

-Mike
