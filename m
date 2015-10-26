From: Neil Brown <neilb@suse.com>
Subject: Re: Remove inactive array created by open
Date: Tue, 27 Oct 2015 07:10:47 +0900
Message-ID: <87a8r5e0wo.fsf@notabene.neil.brown.name>
References: <20151022162445.GA11904@kw.sim.vm.gnt> <87vb9yzjfp.fsf@notabene.neil.brown.name> <20151026211252.GC4665@kw.sim.vm.gnt>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151026211252.GC4665@kw.sim.vm.gnt>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: linux-raid@vger.kernel.org, Remi Reroller <remi.rerolle@seagate.com>, Vincent Donnefort <vdonnefort@gmail.com>, Yoann Sculo <yoann@printk.fr>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27 2015, Simon Guinot wrote:

> On Fri, Oct 23, 2015 at 08:23:38AM +1100, Neil Brown wrote:
>> Simon Guinot <simon.guinot@sequanux.org> writes:
>>=20
>> > Hi Neil,
>> >
>> > I'd like to have your advice about destroying an array created by open
>> > at close time if not configured, rather than waiting for a ioctl or a
>> > sysfs configuration. This would allow to get rid of the inactive md
>> > devices created by an "accidental" open.
>> >
>> > On the Linux distribution embedded in LaCie NAS, we are able to
>> > observe the following scenario:
>> >
>> > 1. A RAID array is stopped with a command such as mdadm --stop /dev/md=
x.
>> > 2. The node /dev/mdx is still available because not removed by mdadm at
>> >    stop.
>> > 3. /dev/mdx is opened by a process such as udev or mdadm --monitor.
>> > 4. An inactive RAID array mdx is created and a "add" uevent is
>> >    broadcasted to userland. It is let to userland to understand that
>> >    this event must be discarded.
>> >
>> > You have to admit that this behaviour is at best awkward :)
>>=20
>> No argument there.
>>=20
>>=20
>> >
>> > I read the commit d3374825ce57
>> > "md: make devices disappear when they are no longer needed" in which
>> > you express some concerns about an infinite loop due to udev always
>> > opening newly created devices. Is that still actual ?
>> >
>> > In your opinion, how could we get rid of an inactive RAID array created
>> > by open ? Maybe we could switch the hold_active flag from UNTIL_IOCTL =
to
>> > 0 after some delay (enough to prevent udev from looping) ? In addition,
>> > maybe we could remove the device node from mdadm --stop ? Or maybe
>> > something else :)
>> >
>> > If you are interested by any of this solutions or one of yours, I'll
>> > be happy to work on it.
>>=20
>> By far the best solution here is to used named md devices.  These are
>> relatively recent and I wouldn't be surprised if you weren't aware of
>> them.
>>=20
>> md devices 9,0 to 9,511 (those are major,minor numbers) are "numeric" md
>> devices.  They have in-kernel names md%d which appear in /proc/mdstat
>> and /sys/block/
>>=20
>> If you create a block-special-device node with these numbers, that will
>> create the md device if it doesn't already exist.
>>=20
>> md devices 9,512 to 9,$BIGNUM are "named" md devices.  These have
>> in-kernel names like md_whatever-you-like.
>> If you create a block-special-device with device number 9,512 and try to
>> open it you will get -ENODEV.
>> To create these you
>>    echo whatever-you-like >  /sys/module/md_mod/parameters/new_array
>>=20
>> A number 512 or greater will be allocated as the minor number.
>>=20
>> These arrays behave as you would want them to.  They are only created
>> when explicitly requested and they disappear when stopped.
>>=20
>> mdadm will create this sort of array if you add
>>  CREATE names=3Dyes
>> to mdadm.conf and don't use numeric device names.
>> i.e. if you ask for /dev/md0, you will still get 9,0.
>> But if you ask for /dev/md/home, you will get 9,512 where as
>> with names=3Dno (the default) you would probably get 9,127.
>
> Thanks for describing the usage of the named md devices. We will look
> to convert our userland from numeric to named md devices.

I think that is the best approach if you can make it work=20
>
>>=20
>> A timeout for dropping idle numeric md devices might make sense but it
>> would need to be several seconds at least as udev can sometimes get very
>> backlogged and would wouldn't want to add to that.  Would 5 minutes be
>> soon enough to meet your need?
>
> No unfortunately, this will not. In our case, I think we need to
> remove the inactive numeric md device at close or quickly after.
>
> Considering that for a numeric md device we need to add the gendisk at
> probe and that we can't destroy it at close if inactive (due to the udev
> issue), then I don't think there is a solution to our problem. But I was
> kind of hoping you had an idea :)

The only thing I can think of is suppressing the ADD uevent until
something happens which would make the device more permanent.  However I
suspect that would require and ugly hack so I have serious doubts about
it being accepted upstream (I'm not sure I would accept it :-)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWLqToAAoJEDnsnt1WYoG5e5oQAK4Cw2vXFIja3wOb9uz5jh+W
5ARUfMHUEULX3KOvMR7me3zLrgvmjIB+FthNxNAorQaJxFWQcDChDrpj58olG4n/
aDxePEPd9ZmD3KsmC/CE8mWj5m4csf3PW5k8V3kzIlt803I93bn5JAAXN6JGB6ln
2XZ7B5QBFfut+Wl/Ph+yWkHQy3/oNJrGRzM1hhjrYHQeuT5hZdrsNqKCt3+FijwI
A8lxy+jbNpSI0LHsIbnf5lbu4l5cFgm2tHcLlLWSJCwDbYU8chzAp4AcEPpNetdl
1MfgIEhtvWU8u4NdE1MkrT8ROkl32WCtuas0y3j0fgn28Wic0ZGIOmGmwXMevK8h
s6BUm4SrODkyU3Goa/ux+TJMSGScYHGOK+c6L2BUjr0XcJZphHYZLvjL8xtfRx2z
OVtfM7pNEm0np7uLgUvRy99TMvUqsccfZViXFzGpw2voR+zaA13WfBT1O6Jtd7+t
cjtRKvuuzaRmnYih2q2787mA6SG7D2GSN8gpefjdij1H46YM1+P5lDa9rLNFBzTY
PoSVILMGjHoDtH51Gsw1WeNEMI310itFeysreDQClIlT99dKzMUuz6XTNc8MvK5/
a7KbLpwqxuaOgov6zFCvkdLMAa2P/aZ1IKv55VhDZ5ghfo6C/cwSGj73OIpU7lqf
VBcSgAKcU6oZ2aE4iPya
=rCtS
-----END PGP SIGNATURE-----
--=-=-=--
