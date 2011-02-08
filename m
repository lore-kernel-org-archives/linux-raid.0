From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 with rotating offsite disks for backup
Date: Tue, 8 Feb 2011 01:40:12 -0200
Message-ID: <AANLkTik8H8m3gVWbuux4W946XxcD=7x88M=hzJA9YQGs@mail.gmail.com>
References: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>
	<20110208030417.GA65865@cons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110208030417.GA65865@cons.org>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Cracauer <cracauer@cons.org>
Cc: Jeff Klingner <klingner@stanford.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i think you could use snapshot at filesystem or lvm level
use a backup disk (it's don't have many operations)
on raid use a write-mostly and the other just for write
the first disk to crash is the read/write (more operations)
the second: write-mostly
the third the snapshot/rsync/backup

it's a probability not a real situation... but it's nice =3D]
if you don't want performace :)

2011/2/8 Martin Cracauer <cracauer@cons.org>:
> Jeff Klingner wrote on Mon, Feb 07, 2011 at 03:53:46PM -0800:
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
> You are aware that this will only work reliably if at the point of
> time when you remove the disk the filesystem(s) on it are one of:
> - mounted readonly
> - unmounted
> - machine is off
>
> Linux doesn't really have a `umount -f`, so the first two options onl=
y
> work if you can get rid of all processes that might want to hold on t=
o
> the filesystem at the time when you want to remove your disk. =A0A
> possible hack is going through a NFS mount which does support forcefu=
l
> operations on the filesystem in Linux.
>
> As has been pointed out, you don't gain much from the added
> complexity. =A0If you would just rsync to one of the spare drives you
> would only copy over what actually changed, and not do a full re-sync
> of all blocks. =A0And that works fine with the source filesystem bein=
g
> mounted read-write.
>
> Another problem is that you are temporarily screwed if disk A dies
> while re-syncing B, since C isn't with you, A is hosed and B is
> half-synced.
>
> What you do lose is that the raid1 based solution would keep the new
> disk up-to-date with then-new file disk writes. =A0But the problem wi=
th
> filesystem status is hard to solve. =A0Overall going 4 disks with rai=
d1
> local and having two disks that are rsynced on demand is what I would
> do.
>
> Martin
> --
> %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
> Martin Cracauer <cracauer@cons.org> =A0 http://www.cons.org/cracauer/
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
