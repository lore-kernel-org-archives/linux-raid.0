From: NeilBrown <neilb@suse.de>
Subject: Re: All kinds of things on RAID/mdadm
Date: Thu, 10 Nov 2011 08:56:11 +1100
Message-ID: <20111110085611.1f555ccf@notabene.brown>
References: <4EB7D340.80009@mindconnect.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pzVTjs8LwXxtjXTrC2Te1BL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EB7D340.80009@mindconnect.nl>
Sender: linux-raid-owner@vger.kernel.org
To: mailinglist@mindconnect.nl
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/pzVTjs8LwXxtjXTrC2Te1BL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 07 Nov 2011 13:46:56 +0100 Martijn <mailinglist@mindconnect.nl> wro=
te:

> Dear readers, perhaps Neil and/or fellow mdadm developers,
>=20
> Over the last couple of weeks, I've been spending quite some time with=20
> mdadm and looking at a good way to use RAID on Linux for one of our=20
> servers. My colleagues (friends) and me are designing a new software=20
> platform for our company service, and RAID is an important base layer in=
=20
> the system.
>=20
> To give you some context: our company was started not only to provide=20
> paid services, but also for learning purposes. We where all students=20
> when we started our company over nine years ago, and we still like to=20
> learn things related to all kinds of (IT) subjects. In that same=20
> direction, because we want to learn, we fancy a certain kind of=20
> 'thoroughness' when creating and documenting something. At least, when=20
> we're given the time to do that, such as in this case.
>=20
> Our current platform was set up early in 2005, when a colleague and I=20
> spent an evening finding out if we *really* couldn't just mirror full=20
> /dev/hda with /dev/hdb ;-) After reading it wasn't possible many, many=20
> times, we ended up manually copying partition tables from hda to hdb=20
> (eek!), mirroring partitions instead of drives (huh?), using some LVM=20
> (every time you think you know how it works, it's different), installing=
=20
> grub on both drives ("will this work on failover?"), and.. it worked.
>=20
> I really slept bad after that though: we needed the reliability cheap,=20
> but it was so different from what I had imagined upfront and knew from=20
> hardware RAID. The extra complexity was a big deal for me too. Bigger=20
> than necessary I think. But I wanted to be more sure I could wrap my=20
> head around a problem if someone would call me in the middle of the=20
> night to fix it.
>=20
> So this time around, I choose to be more thorough on the important=20
> aspects and one of those aspects is: recovery and what to do if=20
> something is wrong. While mdadm is a tool that's pretty clear in it's=20
> usage, supported by a good manual, I've come accross some things I=20
> cannot document to my full satisfaction after reading the manual.=20
> raid.wiki.kernel.org is down as well, and ironically the contents aren't=
=20
> 'mirrored' anywhere. Google Cache may have it, but I can't find it: the=20
> results are littered with non-important meta pages from the wiki.
> I also quickly searched through the mdadm code, but didn't see comments=20
> that cleared up my questions.
>=20
> Searching for possible states of an array, I discovered that there are=20
> all sorts of combinations for states. The basics are clean, degraded and=
=20
> dirty. But what does 'clean, no-errors' mean? And 'dirty, no-errors'?=20
> Searching through the code, I even found a point where a label 'Dirty=20
> State' could be listed as 'clean'. Is it a good idea to add a list with=20
> explainations of possible states, basic and exotic, to the manual? Much=20
> in the same way all monitor events are listed. I can imagine not=20
> everyone knowing the difference between dirty and degraded for example.=20
> It's a basic thing that is skipped in most cases.

The basics are really:

 - clean or dirty  (where 'dirty' is sometimes called 'active')
 - optimal or degraded or failed

There two sets are independent, though a RAID4,5,6 array which is both dirty
and degraded cannot be started without "--force" as there could be corrupti=
on.

Where are you getting the "no-errors" messages from?


>=20
> Perhaps the same could be done for individual disk states. Of course we=20
> all know "active sync", and based on what I've seen elsewhere the states=
=20
> "removed", "spare" and "faulty spare" exist. But having a list of all=20
> possible states would help prepare documentation for the things we=20
> really don't want to happen. Takes off the pressure a bit :-)

I don't think "faulty spare" is a meaningful state. Where did you see that?

A device can be:
 faulty or missing or removed
 spare
 active, but not yet fully in-sync
 active, sync

>=20
> I'm not voting for mdadm to become a tool that even babies can use to=20
> create their arrays, but with this info others may be able to act with=20
> confidence based on their own knowledge, instead of search for articles=20
> on the web that happen to list the state of the array they're searching=20
> for. A lot of those articles do not teach anything. They just make you=20
> brainlessly copy and paste commands and fill in the character device=20
> files. Some of them are just plain wrong and may result in data being los=
t.
> I also vote on articles giving partitionable devices a good kick over=20
> using partitions for RAID, but that's outside the scope of this post ;-)
>=20
> Where do you think that important things, such as to 'how to organize=20
> failover' and questions like 'do I benifit from putting swap on a RAID=20
> char. device', should be documented? Is it the currently unreachable=20
> raid.wiki.kernel.org? Would it be better to provide the info that leads=20
> to the answers in the mdadm manual so that it is always available?

I'm not sure man pages are the right place for some of this, though there is
certainly room for improvement in the man pages and I'm happy to take
contributions.

If we wanted a document that talked about best-practice and swap and so for=
th
I would suggest an 'info' document would be the right sort of format.


>=20
> Are there any sources you would recommend reading if someone is=20
> interested in how mdadm/software-RAID 'works'? I'm not sure if RAID has=20
> an actual spec somewhere on which mdadm is based.

The wikipedia entry isn't bad.

>=20
> Looking forward to your replies and maybe a conversation leading to=20
> improvement where necessary :-)
>=20
> Kind regards,
> Martijn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

NeilBrown


--Sig_/pzVTjs8LwXxtjXTrC2Te1BL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrr2+znsnt1WYoG5AQIItBAAtjBmGOyC6d7qaiSDjnnDlBAB1FkXT7RC
NA6BOizCz273NB684Py26K3dvzcRCfZWvVfOjRyOnwIlsjwWqQ5At/QkXAflzls0
YytcJm3e0A0Xg6E/rifjFf1LHW0LnCQHMGlqn12oIzTw25gC0czI6YciOWaOIecL
B9tT4LM7IvAuhztOgB09BWNa8ehQKsADvAqIpfLi3DDGJRk38UIZvOOIVdtw7EOP
gJPm07XStOrxN1i8/egVrlNY+Rt5WVSRI8V8zyuDnwX5gYl5hRfo0awe0qOsqE0t
FFQJg6eTvZPR19T8/kycf+WGj2BGnkknrZSgcI20DIkVElM9ea3XWeQULMJzzwH5
R6DSLsQ8trqZcsKTWJIiJtDEdBgkxq3d3peG4dF4b1S4voTP7LC5CoA4US9Dre2A
VUVVQhAS6Ahxi/+kLIXoGM+yzIyiq5USUC4AQ6DNjgywMcxshwjBTumb1SCnq8yb
X/bbwhqJW/ZzAOdoKok8s/SNfierkquZVb6ccNpCKTt+3XuxhhnFv3IHRJRIIyg7
+KYzELcZGvi3IxHUo0c8qvBTUuGEcsm3wAeEUNX27HLsMsci3NpbH70y5vJ6G67N
gHlMaD6Ge5cqEWc1gPYfqhKTEDg4PUCSNY4WQpJa4fzbe4YXYbtpSN/UKIGObgZ2
EID5HnQ2xJI=
=PGOb
-----END PGP SIGNATURE-----

--Sig_/pzVTjs8LwXxtjXTrC2Te1BL--
