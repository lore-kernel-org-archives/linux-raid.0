From: d tbsky <tbskyd@gmail.com>
Subject: Re: suggest disk numbers in a raidset?
Date: Sat, 21 May 2016 15:52:13 +0800
Message-ID: <CAC6SzH+MEJHmec7_9NF3u7zjW0C46LozJUKfo4Oy3faySCRpXw@mail.gmail.com>
References: <CAC6SzHJ8Wi18opzDbzjtT+niM5QKOyOU3AAeo0npbDsV+sQOTQ@mail.gmail.com>
	<22335.8101.224476.822021@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22335.8101.224476.822021@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2016-05-20 22:31 GMT+08:00 John Stoffel <john@stoffel.org>:
> I wouldn't even think of using hardware RAID in this situation, and
> I'd also not think about maximizing the size of the RAID6 volumes as
> well, due to rebuild speed penalty.  Another issue to think about is
> chunk size as the number of members in a RAID array go up.  Say you
> have the default 64k block size (number pulled from thin air...), so
> you need to have N * 64K worth of data before you can write a full
> stripe of data.  So as your writing data, you'll want to keep the
> block size down.

thanks for sharing the thought. maybe I should lower the chunk size
for full stripe write.

> But back to goal.  If you're writing large files, since I think NVR
> refers to CCTV camera files, please correct me if wrong, you should
> just stick with the defaults in terms of RAID defaults.

yes NVR refers CCTV files.

> What I would do just just create a RAID6 array with 10 disks, so you
> only have 8 x 4Tb of data, with two parity disks.  Then create another
> RAID6 with the remainng 10 disks.  Then you would add them as PVs into
> LVM, and then stripe acroos them.  Something like this:

yes I will use lvm to combine the array if necessary.
but 10 disks with raid6 will use only 80% of disk capacity.
I had use 16 disks before and it seems ok.

>   # Since you want large space, make the extents use larger chunks here
>   # in the VG.
>   vgcreate -s 16 NVR /dev/md100 /dev/md101

  thanks for the suggestion. I will study it.

> I'd want redundant power supplies, some hot spare disks, a UPS, and a
> rock solid hardware with plenty of memory.  The other issue is that
> unless you run a recent linux kernel, you might run into performance
> problems with the RAID5/6 parity calculations being all done on a
> single CPU core.  Newer versions should have fixed this, but I don't
> recall the exact version right now.

   yes server hardware and environment is ready.

> Also, think about backups.  With this size of a system, backups are
> going to be painful.... but maybe you don't care about backups of NVR
> files past a certain time?

   no backup for this indeed. if the data gone, just let time to re-collect it.
   thanks again for your sharing!!

Regards,
tbskyd
