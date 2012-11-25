From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Re: Where can i download mdadm 3.3
Date: Sun, 25 Nov 2012 10:30:10 -0300
Message-ID: <CAGmni9pqesseBqR-Udczt2BP8ewUguEawAZ=cLQW=nOPqFx-gQ@mail.gmail.com>
References: <CAGmni9ozPTrqeg+RLBu=J8NEqqK95nwf0ymK7qA7DgpZNRHX=A@mail.gmail.com>
 <20121120122622.34f9bacd@notabene.brown> <CAGmni9oWcBYNyfKW4YQUPORRgz+hPM1tQ_jzWrOiNyZV2UmPEA@mail.gmail.com>
 <CAGmni9rkwQO4iHjg+tHSiPQm7Hx_y86cgBUfyio=HrR1Sp9TDg@mail.gmail.com> <20121121082500.411ea21b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121082500.411ea21b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 20, 2012 at 6:25 PM, NeilBrown <neilb@suse.de> wrote:
>
> On Tue, 20 Nov 2012 14:00:35 -0300 Salatiel Filho <salatiel.filho@gmail.com>
> wrote:
>
> > []'s
> > Salatiel
> >
> >
> > On Tue, Nov 20, 2012 at 8:02 AM, Salatiel Filho
> > <salatiel.filho@gmail.com> wrote:
> > > Thanks Neil !
> > > []'s
> > > Salatiel
> > >
> > >
> > > On Mon, Nov 19, 2012 at 10:26 PM, NeilBrown <neilb@suse.de> wrote:
> > >> On Sun, 18 Nov 2012 10:42:22 -0300 Salatiel Filho <salatiel.filho@gmail.com>
> > >> wrote:
> > >>
> > >>> Hi guys, i will be building a few arrays very soon and i'd like to
> > >>> test the badblock feature and the replaceable feature, but i haven`t
> > >>> found where i can download the source of mdadm 1.3. Where can i get it
> > >>> ?
> > >>>
> > >> You can't.  3.3 doesn't exist yet.
> > >>
> > >> However
> > >>   git clone git://neil.brown.name/mdadm
> > >>   cd mdadm
> > >>   make
> > >>
> > >> will get you code that supports bad blocks and replaceable devices.
> > >>
> > >> Alternately you can get a tar file at
> > >>
> > >>    http://git.neil.brown.name/git?p=mdadm.git;a=snapshot;h=master
> > >>
> > >> NeilBrown
> >
> > Forgot to send a copy to the list:
> >
> >
> > Now the question, how do i enable badblock list ?
> > # mdadm -A /dev/md1 /dev/sd[bcd]2 --update=bbl  ?
>
> Yes, I think that is right - does it work?
>
> >
> > I actually created also a new array
> > # mdadm -C -n4 -l5 -e 1.2 /dev/md2 /dev/sd[bcde]3 ,
> > but how do i verify if badblock support was enabled ?
>
> mdadm -E /dev/sdb3
>
> should show
>
>    Bad Block Log : 512 entries available at offset xxx sectors
>
> NeilBrown
>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


Well, about the tests:
I have put some data on a degraded raid 5 with 3 disks where one of
them has random read errors. After that i added a new disk and the
raid started to resync.
After 62.5% i started getting read errors on /dev/sdd2 and the array
stopped to resync.

1) Shouldn`t badblocks be ignored to allow the recover of most data?
I can see in mdadm -E /dev/sdd2   Bad Block Log : 512 entries
available at offset 262128 sectors - bad blocks present.

2) After stop the array and try to reassembled with   mdadm -A
/dev/md1 /dev/sd[bcde]2 --force i got the following message:
mdadm -A /dev/md1 /dev/sd[bcde]2 --force
mdadm: forcing event count in /dev/sdb2(0) from 87705 upto 87713
mdadm: forcing event count in /dev/sdc2(1) from 87705 upto 87713
mdadm: /dev/md1 has been started with 3 drives (out of 4).

and i noticed that sde2 was not added to the array.

# mdadm -D /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Tue Nov 20 08:43:35 2012
     Raid Level : raid5
     Array Size : 3918320640 (3736.80 GiB 4012.36 GB)
  Used Dev Size : 1306106880 (1245.60 GiB 1337.45 GB)
   Raid Devices : 4
  Total Devices : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Nov 25 10:04:06 2012
          State : active, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : zotac:1  (local to host zotac)
           UUID : 93e55a39:94681b9d:4c0a1a15:cad51a71
         Events : 87713

    Number   Major   Minor   RaidDevice State
       0       8       18        0      active sync   /dev/sdb2
       1       8       34        1      active sync   /dev/sdc2
       2       8       50        2      active sync   /dev/sdd2
       6       0        0        6      removed


After add it manually , mdadm -a /dev/md1 /dev/sde2
the rebuild started from the beginning, ignoring the recovery offset:

# mdadm -E /dev/sde2
/dev/sde2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0xb
     Array UUID : 93e55a39:94681b9d:4c0a1a15:cad51a71
           Name : zotac:1  (local to host zotac)
  Creation Time : Tue Nov 20 08:43:35 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3592190757 (1712.89 GiB 1839.20 GB)
     Array Size : 3918320640 (3736.80 GiB 4012.36 GB)
  Used Dev Size : 2612213760 (1245.60 GiB 1337.45 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
Recovery Offset : 1634547480 sectors
          State : clean
    Device UUID : 08019409:984c2217:21706201:039b6bbf

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Nov 25 10:04:06 2012
  Bad Block Log : 512 entries available at offset 262128 sectors
       Checksum : bd6c4947 - correct
         Events : 87705

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)



3) What's the correct procedure that allows me recover most of the
data, ignoring the readerrors ?

4) I know that sdd2 has read errors at  sectors 1634863440 -
1634863800, if i write zero directly to those sectors using 'dd' , how
will raid behave during rebuild? After a write it will probably be
able to read it again (i dont care about the data on those sectors) .

5) Right now i am not using replaceable option , but where replaceable
option could help me here ?


Thanks !
