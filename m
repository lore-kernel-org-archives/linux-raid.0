From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID Configuration For New Home Server
Date: Sat, 5 Jun 2010 19:43:37 -0700
Message-ID: <AANLkTil0Y-mXuoibzPUWtxKML8K0iRaz9mCxL3_40XSB@mail.gmail.com>
References: <AANLkTinbN9-ne0ySKq-GRGLiIhHopH_a-vtysx7yjmob@mail.gmail.com>
	<6B.E5.17309.334EA0C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6B.E5.17309.334EA0C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Carlos Mennens <carloswill@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jun 5, 2010 at 4:56 PM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0It's certainly workable. =C2=A0You migh=
t consider something other than
>> > RAID1 for your swap partition.
>>
>> Looks reasonable. Some comments:
>>
>> 1) I didn't bother using RAID on my /boot. I just installed grub on
>> each of the 3 drives but only boot from the first one. If that
>> partition goes bad I can boot from the second or third drive any tim=
e
>> by just telling BIOS to use a different drive. This saves me from
>> dealing with any mkinitrd stuff. I've never had a boot partition go
>> bad because of the drive itself in 14 years running Linux. They go b=
ad
>> because I write the wrong stuff there. RAID doesn't solve that
>> problem. This method does require that I update the two backups by
>> hand once in awhile. That's OK by me.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Define, "once in awhile [sic]".

Every 2-3 months I make sure each drive is up to date.

> It's certainly possible to do it,
> but the very reason I went with boot arrays rather than boot partitio=
ns was
> it was getting to be a pain to update the backup drives all the time.

All the time vs once every 2-3 months.

Even an out-of-date boot drive will allow me to boot the machine and
get things fixed.

> Almost every time a package is added or deleted, /etc gets updated. =C2=
=A0Keeping
> different copies of the configuration files in /etc in the initrd and=
 the
> root partition is not the best of ideas, although if course it can be=
 done.

As I said I don't using an initrd. I've never learned how to build one
and didn't need it if I didn't use RAID on /boot.

I don't understand your comments about /etc as it's not kept in /boot.
/etc, /, /home, and all other directories are on RAID. Only /boot
isn't, so it needs only a kernel and grub.

> Any package which must be available at boot *MUST* update initrd, and=
 if
> most distro packages are anything, it is update rich.
>
>> 2) I don't use RAID for swap. I let the kernel do that internally. I
>> almost never swap out on my home server so trying to protect that wi=
th
>> RAID for the few moments I might use it seems like overkill to me.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I halfway agree. =C2=A0My servers almost n=
ever use any significant amount
> of swap, and even my workstations only use it very occasionally. =C2=A0=
There have
> been instances, however, where the swap has grown to be quite large. =
=C2=A0With
> that in mind, and given the very small amount he has allocated for sw=
ap, one
> might suggest a RAID0 array of the areas to be used for swap, or mayb=
e an
> LVM volume.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
