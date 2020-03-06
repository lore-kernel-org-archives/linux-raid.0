From: William Morgan <therealbrewer@gmail.com>
Subject: Re: Need help with degraded raid 5
Date: Fri, 6 Mar 2020 15:33:45 -0600
Message-ID: <CALc6PW6HYK_6UAtUVz4nmXF=BOwRrkt9HQFb0wpL5BM8tU9N4w@mail.gmail.com>
References: <CALc6PW74+m1tk4BGgyQRCcx1cU5W=DKWL1mq7EpriW6s=JajVg@mail.gmail.com>
 <CAD9gYJ+3gP+6aannsjzq=L0DsQ-dC2wj4SJfU3+n-t3pG0q3pg@mail.gmail.com> <5E61354C.2090901@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E61354C.2090901@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Jinpu Wang <jinpuwang@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 5, 2020 at 11:22 AM Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 05/03/20 14:53, Jinpu Wang wrote:
> > "mdadm /dev/md0 -a /dev/sdl1"  should work for you to add the disk
> > back to array, maybe you can check first with "mdadm -E /dev/sdl1" to
> > make sure.
>
> Or better, --re-add or whatever the option is. If it can find the
> relevant data in the superblock, like bitmap or journal or whatever, it
> will just bring the disk up-to-date. If it can't, it functions just like
> add, so you've lost nothing but might gain a lot.
>
> Cheers,
> Wol

I tried re-add and I get the following error:

bill@bill-desk:~$ sudo mdadm /dev/md0 --re-add /dev/sdl1
mdadm: Cannot open /dev/sdl1: Device or resource busy

sdl is not mounted, and it doesn't seem to be a device mapper issue:

bill@bill-desk:~$ sudo dmsetup table
No devices found

Here is the current state of sdl:

bill@bill-desk:~$ sudo mdadm -E /dev/sdl1
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x9
     Array UUID : 06ad8de5:3a7a15ad:88116f44:fcdee150
           Name : bill-desk:0  (local to host bill-desk)
  Creation Time : Sat Sep 22 19:10:10 2018
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 15627786240 (7451.91 GiB 8001.43 GB)
     Array Size : 23441679360 (22355.73 GiB 24004.28 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=0 sectors
          State : clean
    Device UUID : 8c628aed:802a5dc8:9d8a8910:9794ec02

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Mar  2 17:41:32 2020
  Bad Block Log : 512 entries available at offset 40 sectors - bad
blocks present.
       Checksum : 7b89f1e6 - correct
         Events : 10749

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : spare
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)

What am I overlooking?
