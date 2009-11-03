From: Stephane Bunel <stephane.bunel@forumdesimages.fr>
Subject: Re: mdadm --detail showing annoying device
Date: Tue, 03 Nov 2009 13:16:22 +0100
Message-ID: <4AF01F16.7000106@forumdesimages.fr>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan> 	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan> <20091020003358.GW9464@discord.disaster> 	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan> <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan> 	<4ADF17EC.6090606@forumdesimages.fr> <19167.33065.766493.889406@notabene.brown> 	<4AE0408C.3090500@forumdesimages.fr> <19177.3970.674526.401872@notabene.brown> 	<4AEFF9EB.2050502@forumdesimages.fr> <aebf5d970911030209l4a99c4f3xd0c4618dbcb5e41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970911030209l4a99c4f3xd0c4618dbcb5e41@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Beolach <beolach@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Beolach a =C3=A9crit :
> On Tue, Nov 3, 2009 at 02:37, Stephane Bunel
> <stephane.bunel@forumdesimages.fr> wrote:
>> Neil Brown a =C3=A9crit :
>> (...)
>>
>>> On your system, /dev/char/21:0 is a block device (or a link to a bl=
ock
>>> device) so there is clearly some sort of configuration error.
>> All files in /dev/char are symlinks (see below). Rules are comming f=
rom
>> Gentoo.
>>
>>> If you still cannot find it, maybe you could show us the change you
>>> made to udev.rules, and an 'ls -l' of '/dev/char'.  That might help
>>> shed some light on your situation.
>> Considering mdadm is only involved by "real" block device file, why =
not just
>> skipping symlink ?
>>
>>  o Udev rules used to rename /dev/sd[ab]:
>>
>> #cat 65-persistent-block.rules
>> ENV{PHYSDEVPATH}=3D=3D"/devices/pci0000:00/0000:00:1f.2/host0/target=
0:0:0/0:0:0:0",
>> NAME=3D"raid_disk0"
>>
>> ENV{PHYSDEVPATH}=3D=3D"/devices/pci0000:00/0000:00:1f.2/host1/target=
1:0:0/1:0:0:0",
>> NAME=3D"raid_disk1"
>>
>=20
> Try prepending SUBSYSTEM=3D=3D"block" to those, so they they'll only =
match
> the (block) sd* devices, and not the (char) sg? devices:
> SUBSYSTEM=3D=3D"block",
> ENV{PHYSDEVPATH}=3D=3D"/devices/pci0000:00/0000:00:1f.2/host0/target0=
:0:0/0:0:0:0",
> NAME=3D"raid_disk0"
> SUBSYSTEM=3D=3D"block",
> ENV{PHYSDEVPATH}=3D=3D"/devices/pci0000:00/0000:00:1f.2/host1/target1=
:0:0/1:0:0:0",
> NAME=3D"raid_disk1"

Well done!! This correct the sg* link issue.

#mdadm --detail /dev/md0
(...)
     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/block/8:0
        1       8       16        1      active sync   /dev/block/8:16
(...)

But we loop back to the original problem. mdadm show '/dev/block/8:0' i=
nstead=20
of '/dev/raid_disk0' (as i wish). This because the symlink '/dev/block/=
8:0' is=20
shorter than the real block file name '/dev/raid_disk0'.

Actual heuristic prevents renaming of real block device name as desired=
 under=20
penalty of seeing symlinks from /dev/block/*.

maybe mdadm could change this behavior by:

  o always prefers real bloc file over symlinks.
  o simply skips symlinks.
  o changing the heuristic like proposed by my patch (prefer the name t=
hat is=20
closer to /dev).


St=C3=A9phane Bunel.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
