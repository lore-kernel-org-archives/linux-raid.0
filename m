From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Reshape 3-drive RAID1 into 3-drive RAID-5
Date: Thu, 17 Nov 2011 13:44:04 -0800
Message-ID: <CAK2H+ee27ukAK08X+ZVPh6t-KH+A0013DR657PJtsuTbq=95gw@mail.gmail.com>
References: <CAK2H+ed1M=_N5rW5Y72Cm0_74ii=-9dCMsB7xJR4FGMST4rCjA@mail.gmail.com>
	<4EC2D58F.3070508@turmel.org>
	<20111116104045.74041bdf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111116104045.74041bdf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 15, 2011 at 3:40 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 15 Nov 2011 16:11:43 -0500 Phil Turmel <philip@turmel.org> wr=
ote:
<SNIP>
>>
>> In your case, the data can be retained, and even remain in use, as f=
ollows:
>>
>> 1) Drop the third device and wipe its superblock.
>>
>> mdadm /dev/md6 --fail /dev/sdc6 --remove /dev/sdc6
>> mdadm --zero-superblock /dev/sdc6
>
> 1a/ Convert the 2-drive RAID1 to a 2-drive RAID1:
> =C2=A0mdadm --grow /dev/md6 --raid-devices=3D2
>
>>
>> 2) Convert 2-drive raid1 to 2-drive raid5. =C2=A0Due to a quirk of t=
he parity math, the second drive contains the same data as the first, a=
nd Neil has optimized this conversion to be instant. =C2=A0(I don't kno=
w what version that became true, but I believe it has been a while.)
> When RAID1->RAID5 conversion was first implemented it was instant - 2=
=2E6.30.
>
>>
>> mdadm /dev/md6 --grow --level=3D5
>>
>> 3) Add third drive as a spare:
>>
>> mdadm /dev/md6 --add /dev/sdc6
>>
>> 4) Reshape/grow to use the new space. =C2=A0MD will re-arrange the b=
locks and compute parity as it goes, without disturbing the running fil=
esystem. =C2=A0You probably need a backup-file option as well... =C2=A0=
mdadm will tell you if it needs it.
>
> You won't. =C2=A0Backups is only needed for the first 6 stripes, and =
the spare can
> be used for that.
>
>>
>> mdadm /dev/md6 --grow --raid-devices=3D3
>>
>> 5) Resize your filesystem to use the additional space.
>>
>> .... (varies, some FS can do it on the run.)
>>
>> >
>> > Thanks,
>> > Mark
>>
>> HTH,
>>
>> Phil
>
> NeilBrown
>

Hi all,
   After reading through your responses and going over the man pages I
got started. Here's the set of commands I have executed so far:

mdadm /dev/md6 --fail /dev/sdc6 --remove /dev/sdc6
mdadm --zero-superblock /dev/sdc6
mdadm --grow /dev/md6 --raid-devices=3D2

At this point I appear to have a good 2-drive RAID-1:

md6 : active raid1 sda6[0] sdb6[1]
      247416933 blocks super 1.1 [2/2] [UU]

The next command was supposed to convert it to RAID-5 but doesn't work
for me so far:

c2stable ~ # mdadm --grow /dev/md6 --level=3D5
mdadm: /dev/md6: could not set level to raid5
c2stable ~ #

   I currently have mdadm-3.1.4 install. Gentoo portage has 3.1.5
marked as testing which I can install if required. Kernel is
3.1.1-gentoo.

   Can you see what I'm doing wrong? I was wondering whether mdadm
needs something like --raid-devices=3D2 to know this is a special
conversion case but don't want to make any stupid mistakes.

Thanks,
Mark

c2stable ~ # mdadm -D /dev/md6
/dev/md6:
        Version : 1.1
  Creation Time : Thu Apr 15 10:45:35 2010
     Raid Level : raid1
     Array Size : 247416933 (235.96 GiB 253.35 GB)
  Used Dev Size : 247416933 (235.96 GiB 253.35 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Thu Nov 17 13:27:20 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : c2stable:6  (local to host c2stable)
           UUID : 249c7331:a8203540:c8f3b020:fb30a66b
         Events : 1039

    Number   Major   Minor   RaidDevice State
       0       8        6        0      active sync   /dev/sda6
       1       8       22        1      active sync   /dev/sdb6
c2stable ~ #
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
