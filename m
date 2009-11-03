From: Beolach <beolach@gmail.com>
Subject: Re: mdadm --detail showing annoying device
Date: Tue, 3 Nov 2009 03:09:56 -0700
Message-ID: <aebf5d970911030209l4a99c4f3xd0c4618dbcb5e41@mail.gmail.com>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
	<alpine.DEB.2.00.0910190431180.23395@p34.internal.lan> <20091020003358.GW9464@discord.disaster>
	<alpine.DEB.2.00.0910200431290.21878@p34.internal.lan> <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
	<4ADF17EC.6090606@forumdesimages.fr> <19167.33065.766493.889406@notabene.brown>
	<4AE0408C.3090500@forumdesimages.fr> <19177.3970.674526.401872@notabene.brown>
	<4AEFF9EB.2050502@forumdesimages.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AEFF9EB.2050502@forumdesimages.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Stephane Bunel <stephane.bunel@forumdesimages.fr>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 3, 2009 at 02:37, Stephane Bunel
<stephane.bunel@forumdesimages.fr> wrote:
> Neil Brown a =C3=A9crit :
> (...)
>
>> On your system, /dev/char/21:0 is a block device (or a link to a blo=
ck
>> device) so there is clearly some sort of configuration error.
>
> All files in /dev/char are symlinks (see below). Rules are comming fr=
om
> Gentoo.
>
>> If you still cannot find it, maybe you could show us the change you
>> made to udev.rules, and an 'ls -l' of '/dev/char'. =C2=A0That might =
help
>> shed some light on your situation.
>
> Considering mdadm is only involved by "real" block device file, why n=
ot just
> skipping symlink ?
>
> =C2=A0o Udev rules used to rename /dev/sd[ab]:
>
> #cat 65-persistent-block.rules
> ENV{PHYSDEVPATH}=3D=3D"/devices/pci0000:00/0000:00:1f.2/host0/target0=
:0:0/0:0:0:0",
> NAME=3D"raid_disk0"
>
> ENV{PHYSDEVPATH}=3D=3D"/devices/pci0000:00/0000:00:1f.2/host1/target1=
:0:0/1:0:0:0",
> NAME=3D"raid_disk1"
>

Try prepending SUBSYSTEM=3D=3D"block" to those, so they they'll only ma=
tch
the (block) sd* devices, and not the (char) sg? devices:
SUBSYSTEM=3D=3D"block",
ENV{PHYSDEVPATH}=3D=3D"/devices/pci0000:00/0000:00:1f.2/host0/target0:0=
:0/0:0:0:0",
NAME=3D"raid_disk0"
SUBSYSTEM=3D=3D"block",
ENV{PHYSDEVPATH}=3D=3D"/devices/pci0000:00/0000:00:1f.2/host1/target1:0=
:0/1:0:0:0",
NAME=3D"raid_disk1"


Good luck,
Conway S. Smith
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
