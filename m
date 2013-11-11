From: joystick <joystick@shiftmail.org>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Mon, 11 Nov 2013 12:06:06 +0100
Message-ID: <5280BA1E.6060604@shiftmail.org>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org> <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: 'joystick' <joystick@shiftmail.org>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/11/2013 10:26, Justin Piszcz wrote:
> -----Original Message-----
> .................
>

Very bad news then. Mismatches belong to occupied filesystem space. 
Seems like your data indeed got corrupted somehow and reading from 
different drives probably returns different content for existing files.

Most likely culprits that come to my mind:

1- MD raid1 bug
2- SSD bug (what brand and model?)
3- Loose SATA cable
4- Linux or SSD bug on trim, such as trimming wrong offsets killing live 
data
5- MD does not lock regions during check so returns erroneous mismatches 
for areas being written. This would be harmless but your mismatches 
number seems to high to me for this.

I would suggest to investigate further. One idea is to find which files 
are affected, then reading from both disks independently you should be 
able to determine if all wrong data are on the same SSD (probable loose 
cable or SSD bug if they are different) or evenly distributed (probable 
MD raid1 bug or SSD bug if they are identical).

The easiest, if it works, would be to determine the location of 
mismatches, and then get the filename from there.
Unfortunately I don't think MD tells you the location of mismatches 
directly. Do you want to try the following:
/sys/block/mdX/md/sync{_min,_max} should allow you to narrow the region 
of the next check. Then check, then cat mismatch_cnt.
Narrow progressively so that you identify one block only. Invoke sync 
and check again same region a couple of times so to be sure that it's 
not due to point 5 above. Then try debugfs (in readonly mode can be used 
with fs mounted), there should be an option to get the inode from the 
block number... I hope that block numbers are not offset by MD... I 
think it's icheck and then you might need find -inum to find the filename.

Now it's better to inspect the file to confirm it has indeed different 
content on the two sides...

activate bitmap for raid1, preferably with small chunksize
fail 1 drive so to degrade raid1
drop caches with blockdev --flushbufs on the md device such as /dev/md2, 
on the two underlying partitions such as /dev/sd[ab]2, and maybe even on 
the two disk holding then such as /dev/sd[ab] (I'm not really sure what 
is the minimum needed) ; and also echo 3 > /proc/sys/vm/drop_caches
cp the file to another filesystem
reattach drive, let it resync the differences using the bitmap
fail the other drive
drop all caches again
cp again file to another filesystem
reattach drive and let it resync

diff the two copied files... what do you see?

BTW can your system be taken offline or is it a production system? If it 
can be taken offline you can easily dump md5sums for all files from both 
sides of the RAID, that would be quicker.

Regards
J.

