From: Marc Smith <msmith626@gmail.com>
Subject: Re: MD Array 'stat' File - Sectors Read
Date: Sat, 11 Apr 2020 00:59:39 -0400
Message-ID: <CAH6h+he2=_1hgBm3hJ4KAnqxHkPgFj3+q-pPTRHrro1vzxgg3w@mail.gmail.com>
References: <CAH6h+heYBA5RvBH7GPJ6JkPUYvjxT2A4f_gBVs=Pr-ps6rPRQw@mail.gmail.com>
 <CAPhsuW4UTJZHSQRHt3V2oPAkz8KD1YpG2YNBBg20cBujTCnzug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4UTJZHSQRHt3V2oPAkz8KD1YpG2YNBBg20cBujTCnzug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 9, 2020 at 3:11 AM Song Liu <song@kernel.org> wrote:
>
> On Mon, Mar 30, 2020 at 1:55 PM Marc Smith <msmith626@gmail.com> wrote:
> >
> > Hi,
> >
> > Apologies in advance, as I'm sure this question has been asked many
> > times and there is a standard answer, but I can't seem to find it on
> > forums or this mailing list.
> >
> > I've always observed this behavior using 'iostat', when looking at
> > READ throughput numbers, the value is about 4 times more than the real
> > throughput number. Knowing this, I typically look at the member
> > devices to determine what throughput is actually being achieved (or
> > from the application driving the I/O).
> >
> > Looking at the sectors read field in the 'stat' file for an MD array
> > block device:
> > # cat /sys/block/md127/stat && sleep 1 && cat /sys/block/md127/stat
> > 93591416        0 55082801792        0       93        0        0
> >   0        0        0        0        0        0        0        0
> > 93608938        0 55092996456        0       93        0        0
> >   0        0        0        0        0        0        0        0
> >
> > 55092996456 - 55082801792 = 10194664
> > 10194664 * 512 = 5219667968
> > 5219667968 / 1024 / 1024 = 4977
> >
> > This device definitely isn't doing 4,977 MiB/s. So now my curiosity is
> > getting to me: Is this just known/expected behavior for the MD array
> > block devices? The numbers for WRITE sectors is always accurate as far
> > as I can tell. Or something configured strangely on my systems?
> >
> > I'm using vanilla Linux 5.4.12.
>
> Thanks for the report. Could you please share output of
>
>    mdadm --detial /dev/md127
>

# mdadm --detail /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Tue Mar 17 17:23:00 2020
        Raid Level : raid6
        Array Size : 17580320640 (16765.90 GiB 18002.25 GB)
     Used Dev Size : 1758032064 (1676.59 GiB 1800.22 GB)
      Raid Devices : 12
     Total Devices : 12
       Persistence : Superblock is persistent

       Update Time : Thu Apr  9 13:07:12 2020
             State : clean
    Active Devices : 12
   Working Devices : 12
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 64K

Consistency Policy : resync

              Name : node-126c4f-1:P2024_126c4f_01  (local to host
node-126c4f-1)
              UUID : ceccb91b:1e975007:3efb5a9d:eda08d04
            Events : 79

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       4       8       64        4      active sync   /dev/sde
       5       8       80        5      active sync
       6       8       96        6      active sync   /dev/sdg
       7       8      112        7      active sync   /dev/sdh
       8       8      128        8      active sync   /dev/sdi
       9       8      144        9      active sync   /dev/sdj
      10       8      160       10      active sync   /dev/sdk
      11       8      176       11      active sync   /dev/sdl


> and
>
>    cat /proc/mdstat

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md127 : active raid6 sda[0] sdl[11] sdk[10] sdj[9] sdi[8] sdh[7]
sdg[6] sdf[5] sde[4] sdd[3] sdc[2] sdb[1]
      17580320640 blocks super 1.2 level 6, 64k chunk, algorithm 2
[12/12] [UUUUUUUUUUUU]

unused devices: <none>


Thanks; please let me know if there is any more detail I can provide.

--Marc


>
> Song
