From: Neil Brown <neilb@suse.com>
Subject: Re: Remove inactive array created by open
Date: Fri, 23 Oct 2015 08:23:38 +1100
Message-ID: <87vb9yzjfp.fsf@notabene.neil.brown.name>
References: <20151022162445.GA11904@kw.sim.vm.gnt>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151022162445.GA11904@kw.sim.vm.gnt>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: linux-raid@vger.kernel.org, Remi Reroller <remi.rerolle@seagate.com>, Vincent Donnefort <vdonnefort@gmail.com>, Yoann Sculo <yoann@printk.fr>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Simon Guinot <simon.guinot@sequanux.org> writes:

> Hi Neil,
>
> I'd like to have your advice about destroying an array created by open
> at close time if not configured, rather than waiting for a ioctl or a
> sysfs configuration. This would allow to get rid of the inactive md
> devices created by an "accidental" open.
>
> On the Linux distribution embedded in LaCie NAS, we are able to
> observe the following scenario:
>
> 1. A RAID array is stopped with a command such as mdadm --stop /dev/mdx.
> 2. The node /dev/mdx is still available because not removed by mdadm at
>    stop.
> 3. /dev/mdx is opened by a process such as udev or mdadm --monitor.
> 4. An inactive RAID array mdx is created and a "add" uevent is
>    broadcasted to userland. It is let to userland to understand that
>    this event must be discarded.
>
> You have to admit that this behaviour is at best awkward :)

No argument there.


>
> I read the commit d3374825ce57
> "md: make devices disappear when they are no longer needed" in which
> you express some concerns about an infinite loop due to udev always
> opening newly created devices. Is that still actual ?
>
> In your opinion, how could we get rid of an inactive RAID array created
> by open ? Maybe we could switch the hold_active flag from UNTIL_IOCTL to
> 0 after some delay (enough to prevent udev from looping) ? In addition,
> maybe we could remove the device node from mdadm --stop ? Or maybe
> something else :)
>
> If you are interested by any of this solutions or one of yours, I'll
> be happy to work on it.

By far the best solution here is to used named md devices.  These are
relatively recent and I wouldn't be surprised if you weren't aware of
them.

md devices 9,0 to 9,511 (those are major,minor numbers) are "numeric" md
devices.  They have in-kernel names md%d which appear in /proc/mdstat
and /sys/block/

If you create a block-special-device node with these numbers, that will
create the md device if it doesn't already exist.

md devices 9,512 to 9,$BIGNUM are "named" md devices.  These have
in-kernel names like md_whatever-you-like.
If you create a block-special-device with device number 9,512 and try to
open it you will get -ENODEV.
To create these you
   echo whatever-you-like >  /sys/module/md_mod/parameters/new_array

A number 512 or greater will be allocated as the minor number.

These arrays behave as you would want them to.  They are only created
when explicitly requested and they disappear when stopped.

mdadm will create this sort of array if you add
 CREATE names=yes
to mdadm.conf and don't use numeric device names.
i.e. if you ask for /dev/md0, you will still get 9,0.
But if you ask for /dev/md/home, you will get 9,512 where as
with names=no (the default) you would probably get 9,127.

A timeout for dropping idle numeric md devices might make sense but it
would need to be several seconds at least as udev can sometimes get very
backlogged and would wouldn't want to add to that.  Would 5 minutes be
soon enough to meet your need?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKVPaAAoJEDnsnt1WYoG5rZ4P/jn+CI0h+aiiPzk20eRolPd5
qn6dfNI+s7o7tXFiTxtCURxDCoW3dTyw86JeO6SEy0q1InBbCm2xFf5oji6VgbMQ
6pMAmXH6YOCTml1nbLgaKU851+yL2fQKcAMMIw0i7D6G0GldEPe7vy4yxQeFExf3
auSL2ljqevYHglf5nDQmoys0wNSxgZ69yPPyCpcySLoYylquX/UfWim0YPZsxjjq
B1v5hfeNduYHBFTExFmANOl1OL/+mkMTAHfHDl/+qEwRAkIcQy8r4lmv7D9Jqf9e
8/gY/376OjvgDgOG+PSTGppyRO3bwGYXB07TWzdfd6JSFA9cmnAXjhw9C6QHzUcg
7AmQ7F5jTyQoPd0ldStuiqJfjXIECZWTER4bIcl1719nqbZZKFq+PwJx2+EmWsJs
iDulSvTyJI4OvF80LurhYaij0JSLcaLnyVbwWSdn9BheKBxcHS+2FL6Lnmbc3aT4
xD1EHjzyHTRf9phWbeUrCQzc5uDv8bq2g9GLrayo6ygSU1x35UTzccwL6gwRf3R+
ic2yiOx0F5d/RT2ZgUDOqvww3VZGigL/TqU+jhtbGggUJSxCqHwcAL0ua0jvyd/5
jhtwEIr06dedsU9z/hZNiKESXqmaf/e3WVrlqCrVkvK4nkD0U/JkahqbmcBOB/SL
NSFn2EfAJrz5VQPS6oyX
=Jzqk
-----END PGP SIGNATURE-----
--=-=-=--
