From: Phil Turmel <philip@turmel.org>
Subject: Re:
Date: Thu, 09 Jun 2011 08:01:16 -0400
Message-ID: <4DF0B60C.9050701@turmel.org>
References: <20110609065059.298530@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609065059.298530@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dragon,

[Fixed subject line]

On 06/09/2011 02:50 AM, Dragon wrote:
> Hi Phil,
> i know that there is something odd with the raid, thats why i need help.
> No i didnt scamble the report. thats what the system output. Sorry for confusing with sdo, this is my usb disk and doesnt belong to the raid. because of the size i didnt have any backup ;(

Well, we don't know yet if your data is intact.  You might get lucky.  For what its worth now, you should know that raid5 isn't considered safe for arrays this size.  When the array is running 12 disks again, you might want to consider using the 13th to change your array to raid6.

> I do not let the system run 24/7 and as i started at in the morning the sequence has changed.

The SCSI driver stack in linux doesn't guarantee the order the drives get named.  And custom udev scripts could massage the names further.

>  fdisk -l |grep sd
> Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdc: 20.4 GB, 20409532416 bytes
> /dev/sdc1   *           1        2372    19053058+  83  Linux
> /dev/sdc2            2373        2481      875542+   5  Extended
> /dev/sdc5            2373        2481      875511   82  Linux swap / Solaris
> Disk /dev/sdd: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sde: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdg: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdf: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdh: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdi: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdj: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdk: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdl: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdm: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdn: 1500.3 GB, 1500301910016 bytes
> Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
> Yesterday was the system on disk sdk. now its on sdc?! the system is now and up to the evening online.
> here the actual data of the drives again:
[...]
> 
> as far as i can see, now there is no error with a missing superblock of one disk.

Well, the superblocks indicate that the array is still configured for 13 drives, two of which are missing.  One of the missing drives has been misidentified as a spare, and the other missing drive ialso thinks it is a spare, but has not been attached.  With your most recent listing, they are /dev/sdd and /dev/sdn.

> 
> how can i download lsdrv with "wget"? Yes the way backwards by shrinking lead to the actual problem.

wget https://github.com/pturmel/lsdrv/raw/master/lsdrv
chmod +x lsdrv
./lsdrv

Phil
