From: Matt Callaghan <matt_callaghan@sympatico.ca>
Subject: Re: Growing Array (More Devices) - new devices are slightly smaller
 than the existing drives, unable to shrink array
Date: Sat, 28 Sep 2013 22:14:46 -0400
Message-ID: <BLU0-SMTP68008539C2D811093BC4ED812B0@phx.gbl>
References: <BLU0-SMTP69424F8624CF692DCD2AD7812A0@phx.gbl> <20130928152857.GA10073@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130928152857.GA10073@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Fantastic thanks Robin! I hadn't noticed the change in the start 
position, thanks for that.
By following your suggestion of copying the partition from existing disk 
to new disk using sfdisk, I was able to successfully create drives with 
the exact same number of blocks.
Subsequently, the array is rebuilding with 2x more drives :)

md2000 : active raid6 sdr1[7] sdq1[6] sdk1[0] sdm1[2] sdn1[3] sdj1[5] 
sdi1[4] sdl1[1]
       7814053632 blocks super 1.1 level 6, 64k chunk, algorithm 2 [8/8] 
[UUUUUUUU]
       [>....................]  reshape =  0.1% (3861120/1953513408) 
finish=1964.3min speed=16540K/sec

Thank you

-------- Original Message --------
From: Robin Hill <robin@robinhill.me.uk>
Sent: Sat 28 Sep 2013 11:28:57 AM EDT
To: Matt Callaghan <matt_callaghan@sympatico.ca>
Cc: linux-raid@vger.kernel.org
Subject: Re: Growing Array (More Devices) - new devices are slightly
smaller than the existing drives, unable to shrink array


> On Sat Sep 28, 2013 at 10:49:49AM -0400, Matt Callaghan wrote:

Hello mdadm Linux-RAID experts;

My Goal: Expand (grow) my array from 6xHDD (RAID6) to 8xHDD (RAID6)

This is my root cause problem: when I went to try to add the new drive
(already formatted for Linux RAID partition):

fermulator@fermmy-server:~$ sudo mdadm --add /dev/md2000 /dev/sdq1
mdadm: /dev/sdq1 not large enough to join array

As I have researched and learned, I need to:
    A) shrink the filesystem (ext4) -- done (shrunk by a generous 1.6GB)
    B) shrink the array size -- incomplete (unable to proceed, the --grow
command doesn't do anything)

I've been following this guide:
http://webapp5.rrz.uni-hamburg.de/SuSe-Dokumentation/manual/sles-manuals_en/manual/raidresize.html#resizedecrraid


This pastebin shows my array details, the 'existing' drives (fdisk) and
'new' drives (fdisk) - http://pastebin.com/U04VJpE4

Any ideas?

Firstly, your new drives are exactly the same size as the old ones:
      Disk /dev/sdk: 2000.4 GB, 2000398934016 bytes
      Disk /dev/sdq: 2000.4 GB, 2000398934016 bytes

Your partition sizes are different though, probably because newer
versions on fdisk default to a higher start point. You can replicate the
partitions from the old disks onto the new ones using sfdisk:
      sfdisk -d /dev/sdk | sfdisk /dev/sdq

You can do the same thing manually using fdisk - just make sure you set
the units to sectors (fdisk -u=sectors) as the cylinder information
differs between the disks (and is obsolete and meaningless).

If you do want to stick with the partitions you have and continue with
shrinking the array, the value passed with the "-z" parameter is the
device size, not the array size. You're passing a value larger than the
disk size, so it's being ignored. It also needs to be a multiple of the
chunk size (64k in your case). So you need to take your 7812441960,
divide by the number of active disks (4) and round up to the nearest
64k. This gives you a new device size of 1953110528.

Cheers,
      Robin


