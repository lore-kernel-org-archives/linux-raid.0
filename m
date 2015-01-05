From: NeilBrown <neilb@suse.de>
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Tue, 6 Jan 2015 07:54:00 +1300
Message-ID: <20150106075400.4a208293@notabene.brown>
References: <20150104210701.GG4713@deb76.aryehleib.com>
	<54A9B472.9090905@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/bKnUyQHZx6l1sa+Y01kx0P2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54A9B472.9090905@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Aryeh Leib Taurog <vim@aryehleib.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/bKnUyQHZx6l1sa+Y01kx0P2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 04 Jan 2015 21:45:22 +0000 Wols Lists <antlists@youngman.org.uk>
wrote:

> On 04/01/15 21:07, Aryeh Leib Taurog wrote:
> > On Sun, 4 Jan 2015 at 11:10 Peter Grandi wrote:
> >> Yet another of an endless (but not too frequent fortunately)
> >> stream of "wildly optimistic" messages to this mailing list...
> >=20
> > No intent to offend.  I specifically put "newbie" in the subject.
> >=20
> >>> Would the resync just copy all the data from the "good" drive
> >>> back to the "failed" drive?
> >>
> >> This seems to me quite "imaginative" based on the dream that
> >> resync has psychic powers.
> >=20
> > I am not sure what you mean.  Two drives in a RAID1 array.  At one=20
> > point, one drive failed to come on line.  Now mdadm refuses to include=
=20
> > that drive in the array.  So there's the "good" drive, which appears=20
> > in the now degraded array, and the "failed" drive, which does not.  I=20
> > have never done a resync, and I haven't seen a detailed description of=
=20
> > what it does, but given that mdadm seems to have decided which drive=20
> > is good and which not, and assuming mdadm doesn't know anything about=20
> > the contents of the data, what is so "imaginative" about the notion=20
> > that if I add the "failed" drive to the array, it would simply copy=20
> > all the data on the "good" drive byte-by-byte onto the "failed" drive,=
=20
> > overwriting whatever is currently on the "failed" drive?  I can't=20
> > imagine how else a resync would work.  What am I missing?
>=20
> That mirroring isn't fault-tolerant-raid? I know it's been given a raid
> classification, but raids 1 and 0 really just give you a bigger faster
> disk. It's only the other raids that have any error correction ability,
> because they use parity etc to be able to tell which set of data is corre=
ct.

Bzzt.  You lose :-)

Of course RAID1 is fault tolerant!! (I agree that RAID0 isn't).

It cannot tolerate every conceivable fault (e.g. asteroid impact), but it
tolerates most single hardware faults.

The fault is detected by the drive, possibly using a CRC, or by the
controller (hmm.. the drive isn't responding, must be faulty!) and this fau=
lt
is communicated to md.  md then manages the fault by accesses the other
device.

*No* RAID level has error detection ability - *all* RAID levels (except zer=
o)
have error correction - providing something else detects the error.
Parity vs mirroring makes no difference here.

(All non-zero RAID levels could try to detect faults by reading all blocks
in a stripe and comparing, but there is no threat-model which makes this a
worthwhile practice)


And to answer the original question: just let it resync.  Had you started
that when you asked the question it would be done by now :-).

To avoid similar problems in future:
 - use a newer mdadm (sorry, but there are bugs sometimes)
 - add an internal write-intent bitmap.  That makes the resync much faster
   when needed
 - Possibly as '--no-degraded' when assembling arrays.

NeilBrown

--Sig_/bKnUyQHZx6l1sa+Y01kx0P2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVKrdyDnsnt1WYoG5AQJoqw/+LdfUdNy/IGf7h3bxsnAdhmC7keDw5nHO
BmA/n/mmEYIchZiJON+Vv5vtI9tduEDjhWTHDWIy3VS05e/ozHJd/cgavzEI224e
JgqyD9MxzY9cpPsWkvI3qss/J3W/2VGlqqa0MnSbdcGVY+7nWEPY7JnbJ2Y0uJRg
1JG/4YLMS6J0AxcyfOv6vlNsJEVLdNqE/2Mj/5mkX/LqZO4WN1CBrOzX1Zx40D6w
5stYGwHR/u1e8zvKe0kcKPSqfg+X7QMN0DcQF+5cLk+WL47eapLf+SKiznnV1Ih6
Q/WKcqzYZXP+zIuVdC/3pk9bsiDbArqGlmt1X3YsJEafNS6YSJsbCPVpfFa4CT6Q
8p27SZddxDai8hGic3z7UaOcIvL9CEdw/OIKtQaM/4DAhishYyxG4KKFionk+zW4
P9tLkWMsF1L9VPDmymsDM/pqEcQXQH50008jASYbFM8rYh24Gaht64tJFF9tvmEb
OdNZ71scCHXEN/6pZyQ9Yz3cni4xUKFryWeRq9SF9mfEo0kq52pKDypfrem15QAX
Kt4N9XEc+ot3d2MGProSYzK6UaUJ830GwZ2MgXoYdU6+0rIRX++PziifRQkGCsog
zucYt/ydhYRRgIXHjj2sexpzbu94Jwa7LgBXEIQIVjxNYeT9+lLy2Wi4OuaU6Zpz
VIAWasmCrPw=
=fIkS
-----END PGP SIGNATURE-----

--Sig_/bKnUyQHZx6l1sa+Y01kx0P2--
