From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC] Process requests instead of bios to use a scheduler
Date: Mon, 2 Jun 2014 20:20:50 +1000
Message-ID: <20140602202050.14903534@notabene.brown>
References: <5385DECE.5060507@profitbricks.com>
	<20140602093258.22aa2c05@notabene.brown>
	<538C4938.6010704@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dyqGMXdqm23gRjlrxpME99N"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <538C4938.6010704@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Florian-Ewald =?UTF-8?B?TcO8?= =?UTF-8?B?bGxlcg==?= <florian-ewald.mueller@profitbricks.com>
List-Id: linux-raid.ids

--Sig_/dyqGMXdqm23gRjlrxpME99N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Jun 2014 11:51:52 +0200 Sebastian Parschauer
<sebastian.riemer@profitbricks.com> wrote:


> > Having a scheduler for RAID0 doesn't make any sense to me.
> > RAID0 simply passes each request down to the appropriate underlying dev=
ice.
> > That device then does its own scheduling.
> >=20
> > Adding a scheduler may well make sense for RAID1 (the current "schedule=
r"
> > only does some read balancing and is rather simplistic) and for RAID4/5=
/6/10.
> >=20
> > But not for RAID0 .... was that a typo?
>=20
> Nope, we have our RAID-1+0. So it is more or less a RAID-10 and putting
> the scheduler to this RAID-0 layer makes sense for us.

I still cannot imagine how this would work.  RAID-0 has no decisions to mak=
e,
so no where for a scheduler to fit.

Just to clarify: is this md/raid0 over md/raid1 or md/raid0 over
hardware/raid1?


> > Could you do a graph?  I like graphs :-)
> > I can certainly seem something has changed here...
>=20
> Sure, please find the graphs attached. I've converted it into percentage
> so that number of bios can be compared to number of requests.

Thanks.

> >=20
> > Show me the code and I might be able to provide a more detailed opinion.
>=20
> I would say let the user decide whether an MD device should be equipped
> with a scheduler or not. We can port our code to latest kernel + latest
> mdadm and send you a patch set for testing. Just give me some time to do =
it.

In the first instance, I just want to get a concrete idea of what you have
done because what you have said doesn't make sense to me.  I'm happy to look
at code against a not-quite-current kernel to get that idea.  But I'm also
happy for it to be against the latest, whatever suits you.

NeilBrown

--Sig_/dyqGMXdqm23gRjlrxpME99N
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4xQAjnsnt1WYoG5AQKJZhAAncoIsuw6ErcQYUqWPXiVaGdkpdPZVJv3
6fUYQ30u1Cu84eBXQWOjtdPntLS0BiW8DumNuUNT4KWyoddJ/VfgYZOveacaCvZg
nBNQkgWhEi4NKhXmxnJ/oa5uK8XkMWHTRU6AcqbsREVQKYocgf3gk+qW8uEGbI4w
MfDDPwg3GkFszU1wQhuEM8nH49EuNxTTVL2CJYadexuOGFAIQHH3JZBlWq/uXfzs
UrTiT0fdvesjaEaT2qoHm44AiHvy9108GG8gqANWfbL6+nzZ58LFg5TmR+xL4EEh
sqm9ub8WzSjxkdbMO268QnQTqyMhspoj/UuexWt1s9JlBisxXCY5gdVmO0IvaDQX
dZe4xja0a3Umh2lpn+XO0ObfH5vz55C7hwnxtVBka7Vop09f0xXKKRJ3QpPoRgGH
Bu4yNKxS3Y7APsDFbNmNw0t3DaDfD7EVZ/yagGke5nkze2wXxoMqhzSjvSo1y01r
Kj5F/Kjqn0WXE6Kpj0StciXAzwkBewiD5dpmLgLIQIvEat9KF56pBcByhf2kDgF8
Vr1Wvmo+ncUM6q5fs5t4XtDXnoVdx4ZjuQs8FgCs79i96OrCc8U6Ebi56Tqm+/Yd
C7OElrE8k3ABgEXG/vclVVS9y9TXvAQEqEKXb/IfEWhyU3dnlxiV7b/mgqkE2HKK
yuGBzy3WQXI=
=GSOm
-----END PGP SIGNATURE-----

--Sig_/dyqGMXdqm23gRjlrxpME99N--
