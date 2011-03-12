From: Rory Jaffe <rsjaffe@gmail.com>
Subject: Re: RAID5 Shrinking array-size nearly killed the system
Date: Sat, 12 Mar 2011 18:31:17 +0000
Message-ID: <AANLkTinjzmGMegWbDA6Zyp-T+AMK5cvf1L2WV_gpPWRi@mail.gmail.com>
References: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com>
	<AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com>
	<alpine.DEB.1.10.1103120655370.7942@uplift.swm.pp.se>
	<4D7B85EB.60505@turmel.org>
	<AANLkTik2qk2ep7fsQPjAesnjur-0AB-Xx7EeZ5YfeCSA@mail.gmail.com>
	<AANLkTikRdqZ4nAdLcUuYz17KeWb54ES_sNYzzW-u1R0x@mail.gmail.com>
	<4D7BB462.5030706@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D7BB462.5030706@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 12, 2011 at 5:58 PM, Phil Turmel <philip@turmel.org> wrote:
>
> [CC restored]
>
> On 03/12/2011 12:37 PM, Rory Jaffe wrote:
> > This is my plan now--did I get this right? -- thanks --
> >
> > shutdown -r now # go to live cd
> > umount /dev/md0 #just to make sure
> > e2fsck /dev/md0
> > resize2fs /dev/md0 3800G #3.2T currently in use
> > shutdown -r now # go back to main system
> > mdadm --grow /dev/md0 --array-size 4000000000
> > mdadm -G -n 4 -x 2 --backup-file=3D/path/to/file.bak /dev/md0
> > resize2fs /dev/md0
>
> I would do everything in the LiveCD environment, and I would add an f=
sck after the resize, and again at the end.
>
> In the LiveCD, there's a good chance the array will be assembled for =
you, but as a different number. =C2=A0That shouldn't cause any problems=
, but it affects the commands you'll type. =C2=A0"cat /proc/mdstat" wil=
l give you a quick summary of where you stand.
>
> I can't comment on the size figures you've chosen, as you haven't sha=
red the output of "mdadm -D /dev/md0" and "mdadm -E" for each of the co=
mponent devices.
>
> Also note that the backup file needed by mdadm cannot be *inside* the=
 array you are resizing. =C2=A0You *must* have another storage device f=
or it. =C2=A0I use a thumb drive with my LiveCD for this kind of task.
>
> Phil
Here's the data on array sizes
sudo mdadm -D /dev/md/0_0
/dev/md/0_0:
        Version : 0.90
  Creation Time : Thu Jan  6 06:13:08 2011
     Raid Level : raid5
     Array Size : 9762687680 (9310.42 GiB 9996.99 GB)
  Used Dev Size : 1952537536 (1862.08 GiB 1999.40 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 127
    Persistence : Superblock is persistent

    Update Time : Sat Mar 12 17:56:34 2011
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 7e946e9d:b6a3395c:b57e8a13:68af0467
         Events : 0.72

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       50        1      active sync   /dev/sdd2
       2       8       66        2      active sync   /dev/sde2
       3       8       82        3      active sync   /dev/sdf2
       4       8       98        4      active sync   /dev/sdg2
       5       8      114        5      active sync   /dev/sdh2
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
