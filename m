From: CoolCold <coolthecold@gmail.com>
Subject: Re: Converting system to raid
Date: Sat, 11 Apr 2009 18:29:48 +0400
Message-ID: <f19d625d0904110729y30e8bc80m41fcd8f2c3298d49@mail.gmail.com>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com>
	 <20090410195303.GB21242@cthulhu.home.robinhill.me.uk>
	 <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg>
	 <20090410205942.GC21242@cthulhu.home.robinhill.me.uk>
	 <00f301c9ba23$032025f0$0a00a8c0@vorg>
	 <20090410215129.GD21242@cthulhu.home.robinhill.me.uk>
	 <019701c9ba66$aeed5630$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <019701c9ba66$aeed5630$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 11, 2009 at 9:29 AM, Timothy D. Lenz <tlenz@vorgon.com> wro=
te:
> From: "CoolCold" <coolthecold@gmail.com>
>
>> Yes, he should provide correct /etc/mdadm/mdadm.conf and
>> update-initramfs -u on md boot, smth like
>> chroot /mnt/md0
>> update-initramfs -u
>
> How would this help in a system that doesn't ramdisk built in to the =
kernel or as a module? Or does it change some other stuff?
Looking into "I have 2 computers that I am trying to convert to raid.
Both where setup with debian netinst cd to hda" - debian has initrd
support within their kernels.
>
>
> I started looking at the stuff that was copied to md0 and /md0/dev is=
 empty. Looking through the guides I found a few things. One
> said that using cp had to be from root or not everything would get co=
ppied. I used sudo but I know some things require you to root.
> Also this:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> # rsync -avHhx --progress / /mnt/raid-md0
>
> =A0 =A0* If the system wasn't previously in single user mode, move to=
 single user mode and update the data that changed during the
> first copy:
> (--delete flag tells rsync to delete files from the destination which=
 do not exist on the source):
>
> # rsync -avHhx --progress --delete / /mnt/raid-md0
>
> =A0 =A0* Create needed device nodes:
>
> # cd /mnt/raid-md0/dev/ && MAKEDEV generic
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> Using rsync from single user mode still left /mnt/md0/dev empty. I re=
ad up in "makedev generic" and it seems to be a shotgun fix
> adding way more then is needed. Is there a way to create just what is=
 in /dev?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
