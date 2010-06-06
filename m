From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID Configuration For New Home Server
Date: Sun, 6 Jun 2010 07:56:04 -0700
Message-ID: <AANLkTinh1WtkzAgS8cOC1idj-7tcS4OMv9s3qRGwdhrf@mail.gmail.com>
References: <3A.AD.03181.3FF2B0C4@cdptpa-omtalb.mail.rr.com>
	<BA.E9.03181.F158B0C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BA.E9.03181.F158B0C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jun 6, 2010 at 4:23 AM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
<SNIP>
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Oh, I almost forgot. =C2=A0It may be of no=
table mention an array with a
> 1.0 superblock can be read as if it were an ordinary partition. =C2=A0=
This means
> one can build a 1.0 superblock array containing a file system (ext2 m=
ay be
> the best choice in this case), but boot from the partition just as if=
 it
> were not an array. =C2=A0Once the system is booted, the array can be =
assembled
> and then /boot can be mounted. =C2=A0This is because:
>
> 1. =C2=A0The 1.0 superblock is at the *END* of the array.
>
> 2. =C2=A0The file system when created only uses up the front part of =
the
> partition, leaving the superblock intact.
>
> 3. =C2=A0GRUB does not require the file system to be mounted in order=
 to read the
> kernel and the initrd. =C2=A0(Actually, it could be made to work even=
 if it did
> mount the partition, but since it does not, it makes it much easier.)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Indeed, this is the only way of which I kn=
ow to boot to an array
> using GRUB legacy.
>
>

Actually that is of interest. If there's a way to use a single RAID
boot partition by itself once in awhile then there's value there if
something has gone wrong and you're just trying to get the machine up
and running.

Thanks!

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
