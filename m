From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 with rotating offsite disks for backup
Date: Wed, 9 Feb 2011 17:53:14 -0200
Message-ID: <AANLkTin6UFR6pR-E+z29kTd9VioRVxQqmOR-ABTnWymu@mail.gmail.com>
References: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
	<AANLkTik+WR5r_xBAFhKrUCwQgAzz+x2_AVQ9vjr=Rdco@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik+WR5r_xBAFhKrUCwQgAzz+x2_AVQ9vjr=Rdco@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: Jeff Klingner <klingner@stanford.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i agree with rsync
rsync is more filesystem related feature
if you want copy files, you should use rsync
if you want to copy the device, may be a dd with devices?
dd if=3D/dev/md0 of=3D/dev/sda

if you want a snapshot copy, you should first remount your filesystem
to readonly (there=B4s no flock() for /dev/md0 since filesystem don=B4t
use flock() on /dev/md0) or another way to block writes to filesystem
while you is read from device, some filesystems have online backup
features..
i don=B4t know lvm very well, but maybe they implement online backup th=
ere...
i don=B4t think it=B4s a problem to solve at md level (it could work, b=
ut
the raid1 purpose is make a fail safe device (or partially safe), not
a online backup device)


2011/2/9  <hansbkk@gmail.com>:
> On Tue, Feb 8, 2011 at 6:53 AM, Jeff Klingner <klingner@stanford.edu>=
 wrote:
>> I'm planning a backup system for my home server and have run into a =
question I can't find answered in the mailing list archives or the wiki=
=2E =A0Here's the plan:
>>
>> 1. Install system and valuable data on a 3-disk raid1 array (call th=
e disks A, B, and C).
>> 2. Remove disk C, put it offsite. =A0("offsite" is moderately time-c=
onsuming to get to.)
>> 3a. Periodically, remove disk B, take it offsite, and retrieve disk =
C
>> 3b. Insert disk C, which will be re-synced to gain any changes made =
since it was removed.
>> 4. Repeat steps 3a and 3b indefinitely, alternating the roles of dis=
ks B and C.
>>
>> Thus I hope to get continuous protection against a single drive fail=
ure and protection back to the last offsite swap for corrupted or delet=
ed data.
>
>
> I went through a (probably much too) long discussion here on similar
> (but more complex) ideas.
>
>
> http://www.issociate.de/board/goto/2050886/Q:_LVM_over_RAID,_or_plain=
_disks?_A:%22Yes%22_=3D_best_of_both_worlds?.html
>
> Bottom line conclusions
> =A0- mdraid isn't designed for this, and may not be as resilient as y=
ou'd expect
> =A0- there is extra overhead involved in the resulting filesystem on
> the member, that in this case doesn't actually help fault-tolerance,
> makes it more difficult to recover your data from the offsite drive,
> and wastes time
> =A0- better to just mount a plain-partitioned disk and rsync for your
> removable offsite backups
>
> In my case, some of the target filesystems (backup targets with
> millions of hardlinks, created by tools like rdiff-backup and
> BackupPC) can't be duplicated at the file-level; I need to copy the
> filesystem using block-level tools, so that's why the end of the
> thread talks about COTS cloning tools as well as FOSS enhanced
> versions of dd.
>
> For regular filesystems, IMO rsync's the way to go.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
