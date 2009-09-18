From: "Majed B." <majedb@gmail.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Fri, 18 Sep 2009 13:52:14 +0300
Message-ID: <70ed7c3e0909180352m152e2237o2c449730660fc0ba@mail.gmail.com>
References: <h8nbt5$n8p$1@ger.gmane.org> <h8nfoe$n8p$3@ger.gmane.org>
	<alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
	<h8nreb$n8p$4@ger.gmane.org> <87ws3z5iro.fsf@frosties.localdomain>
	<1253106813.17888.9.camel@localhost> <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
	<20090918082851.GD22909@cthulhu.home.robinhill.me.uk> <70ed7c3e0909180257hf13ba48va808b942deaba177@mail.gmail.com>
	<20090918102234.GE22909@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090918102234.GE22909@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, I think my case is different Matthias's and I can't reconstruct
the data anymore, as you said, Robin.

So this leaves me with a degraded array with bad sectors and a dodgy fi=
lesystem.

You see, I can mount the LVM Logical Volume (formatted with XFS), but
as soon as I hit some bad sectors, XFS complains and then one of the
array disks jump out.
Just now, one disk exited the array and renamed itself from sdg to sdj
=2E... (this is the first time this happens). According to smartctl -a
/dev/sdj, there are no bad sectors, but I still get this in
/var/log/messages

Sep 18 07:01:38 Adam kernel: [316599.950147] sd 6:0:0:0: [sdg] Result:
hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK,SUGGEST_OK
Sep 18 07:01:38 Adam kernel: [316599.950175] raid5:md0: read error not
correctable (sector 1240859816 on sdg1).
Sep 18 07:01:38 Adam kernel: [316599.950223] raid5:md0: read error not
correctable (sector 1240859824 on sdg1).
Sep 18 07:01:38 Adam kernel: [316599.950225] raid5:md0: read error not
correctable (sector 1240859832 on sdg1).
Sep 18 07:01:38 Adam kernel: [316599.950227] raid5:md0: read error not
correctable (sector 1240859840 on sdg1).
Sep 18 07:01:38 Adam kernel: [316599.950230] raid5:md0: read error not
correctable (sector 1240859848 on sdg1).
Sep 18 07:01:38 Adam kernel: [316599.950232] raid5:md0: read error not
correctable (sector 1240859856 on sdg1).
Sep 18 07:01:38 Adam kernel: [316599.950234] raid5:md0: read error not
correctable (sector 1240859864 on sdg1).
Sep 18 07:01:38 Adam kernel: [316599.950236] raid5:md0: read error not
correctable (sector 1240859872 on sdg1).
Sep 18 07:01:38 Adam kernel: [316599.950238] raid5:md0: read error not
correctable (sector 1240859880 on sdg1).
Sep 18 07:01:38 Adam kernel: [316599.950240] raid5:md0: read error not
correctable (sector 1240859888 on sdg1).

When the disk exits the array, it becomes useless (6 out of 8 disks)
and XFS complains:

Sep 18 07:01:46 Adam kernel: [316607.896293] xfs_imap_to_bp:
xfs_trans_read_buf()returned an error 5 on dm-0.  Returning error.
Sep 18 07:01:46 Adam kernel: [316607.896374] xfs_imap_to_bp:
xfs_trans_read_buf()returned an error 5 on dm-0.  Returning error.
Sep 18 07:01:46 Adam kernel: [316607.896453] xfs_imap_to_bp:
xfs_trans_read_buf()returned an error 5 on dm-0.  Returning error.

Here's some info on smartctl -a /dev/sdg
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age
Always       -       0
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

I can't find an explanation to why disks are behaving this way...

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

Plan B: Since I cloned the disk with bad sectors to another, what
would happen if I zeroed the damaged one then cloned the clone to it?!

I do realize that there will be zeros in the areas of bad sectors, but
how will mdadm/md behave? Would a resync fail?

I can run fsck at that point and files residing on bad sectors will be
the only affected ones, correct?

On Fri, Sep 18, 2009 at 1:22 PM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> On Fri Sep 18, 2009 at 12:57:23PM +0300, Majed B. wrote:
>
>> Thank you for the insight, Robin.
>>
>> I already have used dd_rescue to find which sectors are bad, so I
>> guess I could either wait for Matthias to finish his modifications t=
o
>> mdadm, or I can reconstruct the bad sectors manually (read same sect=
or
>> from other disks, xor all, write to damaged disk's clone).
>>
> This won't work if your array is degraded though - you don't have eno=
ugh
> data to do the reconstruction (unless you have two failed drives you =
can
> partially read?).
>
>> Weird thing though, is that when I re-read some of the bad sectors, =
I
>> didn't get I/O errors ... it's confusing!
>>
> Odd. =C2=A0I'd recommend using ddrescue rather than dd_rescue - it's =
faster
> and handles retries of bad sectors better.
>
>> Also, I'd rather avoid a fsck when I have bad sectors to not lose
>> files. I'll run fsck once I've fixed the bad sectors and resynced th=
e
>> array.
>>
> True - a fsck should only be done once the data's in the best possibl=
e
> state,
>
> Cheers,
> =C2=A0 =C2=A0Robin
> --
> =C2=A0 =C2=A0 ___
> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen in =
de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
