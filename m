From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have
 failed.
Date: Thu, 21 Mar 2013 10:04:50 +1100
Message-ID: <20130321100450.6b82dbfa@notabene.brown>
References: <1363195764.24906.14.camel@f16>
	<20130318104905.4a70bc00@notabene.brown>
	<1C64DEE2-FCED-4B9A-A134-E03EA898A8B7@redhat.com>
	<20130320134611.4c9b0e75@notabene.brown>
	<AE87208C-5B7F-4949-8A99-F8841ADD5B1F@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b8hSFljOVV1uYL_kgqQ+.z2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AE87208C-5B7F-4949-8A99-F8841ADD5B1F@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/b8hSFljOVV1uYL_kgqQ+.z2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Mar 2013 15:56:03 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Mar 19, 2013, at 9:46 PM, NeilBrown wrote:
>=20
> > On Tue, 19 Mar 2013 16:15:35 -0500 Brassow Jonathan <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >>=20
> >> On Mar 17, 2013, at 6:49 PM, NeilBrown wrote:
> >>=20
> >>> On Wed, 13 Mar 2013 12:29:24 -0500 Jonathan Brassow <jbrassow@redhat.=
com>
> >>> wrote:
> >>>=20
> >>>> Neil,
> >>>>=20
> >>>> I've noticed that when too many devices fail in a RAID arrary that
> >>>> addtional I/O will hang, yielding an endless supply of:
> >>>> Mar 12 11:52:53 bp-01 kernel: Buffer I/O error on device md1, logica=
l block 3
> >>>> Mar 12 11:52:53 bp-01 kernel: lost page write due to I/O error on md1
> >>>> Mar 12 11:52:53 bp-01 kernel: sector=3D800 i=3D3           (null)   =
        (null) =20
> >>>>        (null)           (null) 1
> >>>=20
> >>> This is the third report in as many weeks that mentions that WARN_ON.
> >>> The first two where quite different causes.
> >>> I think this one is the same as the first one, which means it would b=
e fixed
> >>> by =20
> >>>     md/raid5: schedule_construction should abort if nothing to do.
> >>>=20
> >>> which is commit 29d90fa2adbdd9f in linux-next.
> >>=20
> >> Sorry, I don't see this commit in linux-next:
> >> (the "for-next" branch of) git://github.com/neilbrown/linux.git
> >> or git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> >>=20
> >> Where should I be looking?
> >=20
> > Sorry, I probably messed up.
> > I meant this commit:
> > http://git.neil.brown.name/?p=3Dmd.git;a=3Dcommitdiff;h=3Dce7d363aaf1e2=
8be8406a2976220944ca487e8ca
>=20
> Yes, I found this patch in 'for-next'.  I tested 3.9.0-rc3 with and witho=
ut this patch.  The good news is that my issue with RAID5 appears to be fix=
ed with this patch.  To test, I simply created a 1GB RAID array, let it syn=
c, killed all of the devices and then issued a 40M write request (4M block =
size).  Before the patch, I would see the kernel warnings and it would take=
 7+ minutes to finish the 40M write.  After the patch, I don't see the kern=
el warnings or call traces and it takes < 1 sec to finish the 40M write.  T=
hat's good.  Will this patch make it back to 3.[78]?
>=20
> However, I also found that RAID1 can take 2.5 min to perform the write an=
d RAID10 can take 9+ min.  Hung task messages with call traces and many man=
y errors are the result.  This is bad.  I haven't figured out why these are=
 so slow yet.

What happens if you take RAID out of the picture?
i.e. write to a single device, then "kill" that device, then try issuing a
40M write request to it.

If that takes 2.5 minutes to resolve, then I think it is correct for RAID1 =
to
also take 2.5 minutes to resolve.=20
If it resolves much more quickly than it does with RAID1, then that is a
problem we should certainly address.


>=20
> On a different topic, I've noticed the following commits in 'for-next':
>   90584fc MD: Prevent sysfs operations on uninitialized kobjects
>   e3620a3 MD RAID5: Avoid accessing gendisk or queue structs when not ava=
ilable
> but these are not in 3.9.0-rc3.  They should make their way into 3.9.0 as=
 well as 3.8.0.  (They apply cleanly to the 3.8 kernel, but I hadn't bother=
ed to notify 'stable' - only mention the regression was introduced in 3.8-r=
c1.)

They are due to be sent to Linus today.
The second one is  tagged for -stable and will go to 3.8.x (I think 3.7.x is
closed).
The first isn't - my quick examination suggested that the current code is
safe but not ideal.  If you think it is appropriate for -stable  (i.e. fixes
a real bug that could hurt users) let me know why and I'll make sure it goes
to -stable.

NeilBrown

--Sig_/b8hSFljOVV1uYL_kgqQ+.z2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUpAkjnsnt1WYoG5AQKDvg//QlBrXW5bEfb7HlwGw+PEsnAi74kptbqE
DEEJkFzp4mEwJoniLUDvcgvztxv67DaSRA848KI8srvoalC7txUQfIZYU82zTEu2
h7Yl/fZYL0nVKebMD8UrdWVCV4sLK69/rxa3Ayeh9AA4O1kjoYj5hW9GPbt/Ht9V
3zZEezK/Vn+eLlkvUEf+cJA5V+i7AM8M/ojAy0N9C8a4rb178ksI9Jr7N6J/A8De
MHd/uARV9BfpA/bqqGHSFGkyi05QrKiVWJzL9i60uxZUSFBUC/JLyLth2yPQ0vAy
ZP9VI/AMMxAcyFKVSzwySTSEgl2tnf8BH7RAp+umNFegO91WlD/HMWP7lZ7k/S1Z
RguILvS5EahWfmE9iIU2pn794NZIldbbFk0BDzTqmgVqNBGDz2WDzdFAO7Hvtj6L
P0D2bCRVtr3tIDfCBydzULpkPJFUT1uc3mU2V0H9kdYp2CheYQCeVY36hUZmO3mw
kdiw54LSK01bWzs1qEMDxXr9bYaSVa7q1pjr7wexTcBa+OE73X+Kmyzv4Q9w3HgZ
gpEQYWZ17kgAlTg8LJd33PnNf2RuYb1qQqiT4qN1H3XVj2IDK6MZa+FfFCKn1Fny
7+F/0pF8qe6wD3GwYRu3J2s1O0dVh0ZL8n5owIOqNjVH3t4VCs3X5Kaa/3KFCpEP
nzmaeAuXkHo=
=PrjR
-----END PGP SIGNATURE-----

--Sig_/b8hSFljOVV1uYL_kgqQ+.z2--
