From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have
 failed.
Date: Thu, 28 Mar 2013 11:13:27 +1100
Message-ID: <20130328111327.0e64cdc6@notabene.brown>
References: <1363195764.24906.14.camel@f16>
	<20130318104905.4a70bc00@notabene.brown>
	<1C64DEE2-FCED-4B9A-A134-E03EA898A8B7@redhat.com>
	<20130320134611.4c9b0e75@notabene.brown>
	<AE87208C-5B7F-4949-8A99-F8841ADD5B1F@redhat.com>
	<20130321100450.6b82dbfa@notabene.brown>
	<6F836B18-FF2D-4CFC-BC1B-5F4F6313DF06@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IbC++g39c_kd7Z=HCc1QbaS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6F836B18-FF2D-4CFC-BC1B-5F4F6313DF06@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/IbC++g39c_kd7Z=HCc1QbaS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 Mar 2013 08:58:54 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Mar 20, 2013, at 6:04 PM, NeilBrown wrote:
>=20
> > On Wed, 20 Mar 2013 15:56:03 -0500 Brassow Jonathan <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >>=20
> >> On Mar 19, 2013, at 9:46 PM, NeilBrown wrote:
> >>=20
> >>> On Tue, 19 Mar 2013 16:15:35 -0500 Brassow Jonathan <jbrassow@redhat.=
com>
> >>> wrote:
> >>>=20
> >>>>=20
> >>>> On Mar 17, 2013, at 6:49 PM, NeilBrown wrote:
> >>>>=20
> >>>>> On Wed, 13 Mar 2013 12:29:24 -0500 Jonathan Brassow <jbrassow@redha=
t.com>
> >>>>> wrote:
> >>>>>=20
> >>>>>> Neil,
> >>>>>>=20
> >>>>>> I've noticed that when too many devices fail in a RAID arrary that
> >>>>>> addtional I/O will hang, yielding an endless supply of:
> >>>>>> Mar 12 11:52:53 bp-01 kernel: Buffer I/O error on device md1, logi=
cal block 3
> >>>>>> Mar 12 11:52:53 bp-01 kernel: lost page write due to I/O error on =
md1
> >>>>>> Mar 12 11:52:53 bp-01 kernel: sector=3D800 i=3D3           (null) =
          (null) =20
> >>>>>>       (null)           (null) 1
> >>>>>=20
> >>>>> This is the third report in as many weeks that mentions that WARN_O=
N.
> >>>>> The first two where quite different causes.
> >>>>> I think this one is the same as the first one, which means it would=
 be fixed
> >>>>> by =20
> >>>>>    md/raid5: schedule_construction should abort if nothing to do.
> >>>>>=20
> >>>>> which is commit 29d90fa2adbdd9f in linux-next.
> >>>>=20
> >>>> Sorry, I don't see this commit in linux-next:
> >>>> (the "for-next" branch of) git://github.com/neilbrown/linux.git
> >>>> or git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> >>>>=20
> >>>> Where should I be looking?
> >>>=20
> >>> Sorry, I probably messed up.
> >>> I meant this commit:
> >>> http://git.neil.brown.name/?p=3Dmd.git;a=3Dcommitdiff;h=3Dce7d363aaf1=
e28be8406a2976220944ca487e8ca
> >>=20
> >> Yes, I found this patch in 'for-next'.  I tested 3.9.0-rc3 with and wi=
thout this patch.  The good news is that my issue with RAID5 appears to be =
fixed with this patch.  To test, I simply created a 1GB RAID array, let it =
sync, killed all of the devices and then issued a 40M write request (4M blo=
ck size).  Before the patch, I would see the kernel warnings and it would t=
ake 7+ minutes to finish the 40M write.  After the patch, I don't see the k=
ernel warnings or call traces and it takes < 1 sec to finish the 40M write.=
  That's good.  Will this patch make it back to 3.[78]?
> >>=20
> >> However, I also found that RAID1 can take 2.5 min to perform the write=
 and RAID10 can take 9+ min.  Hung task messages with call traces and many =
many errors are the result.  This is bad.  I haven't figured out why these =
are so slow yet.
> >=20
> > What happens if you take RAID out of the picture?
> > i.e. write to a single device, then "kill" that device, then try issuin=
g a
> > 40M write request to it.
> >=20
> > If that takes 2.5 minutes to resolve, then I think it is correct for RA=
ID1 to
> > also take 2.5 minutes to resolve.=20
> > If it resolves much more quickly than it does with RAID1, then that is a
> > problem we should certainly address.
>=20
> The test is a little different because once you offline a device, you can=
't open it.  So, I had to start I/O and then kill the device.  I still get =
158MB/s - 3 orders of magnitude faster than RAID1.  Besides, if RAID10 take=
s 9+ minutes to complete, we'd still have something to fix.  I have also te=
sted this with an "error" device and it also returns in sub-second time.
>=20
>  brassow
>=20
> [root@bp-01 ~]# off.sh sda
> Turning off sda
> [root@bp-01 ~]# dd if=3D/dev/zero of=3D/dev/sda1 bs=3D4M count=3D10
> dd: opening `/dev/sda1': No such device or address
> [root@bp-01 ~]# on.sh sda
> Turning on sda
> [root@bp-01 ~]# dd if=3D/dev/zero of=3D/dev/sda bs=3D4M count=3D1000 &
> [1] 5203
> [root@bp-01 ~]# off.sh sda
> Turning off sda
> [root@bp-01 ~]# 1000+0 records in
> 1000+0 records out
> 4194304000 bytes (4.2 GB) copied, 26.5564 s, 158 MB/s
>=20

Maybe if you could show me some/all of the error messages that you get duri=
ng
these long delays it might help.  Also the error messages you (presumably)
got from the kernel from the above plain-disk test.

It should quickly fail all but one copy of the data, then try writing to th=
at
copy exactly the same way that it would write to a plain disk.

For RAID10 large writes have to be chopped up for striping, so the extra
requests which all have to fail could be the reason for the extra delay with
RAID10.

NeilBrown

--Sig_/IbC++g39c_kd7Z=HCc1QbaS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUVOLJznsnt1WYoG5AQKHqQ/+O7Xb+kCv2RphhPJzVjDzj//ne4bZw628
cZiyZauKt2Y4lzQRVubZzGIA/cws4lOlhEiY4hi8NdfIbwnqPqFNcMG7iY8Bv2zB
nZog1DwVvnOCoIw0CWwulilp9MIcn4khOjzwurG589DajEJLirIMjBbMRjvKgRRN
8iG35oOEYrdKDrtHrjGwYO+fBVGpC5cfT4yBLuGFMP0ZK2FKLLj+wnkOaTmciATW
XyPx9r/NYSV0Vqk/NhVZV2RWLj1Ff4fILVGmvRJF2ovsKyqiXxdNyvv48lVGD97U
bUbwRVI14GQQsGbN6MdEM00PO8VT2FsggyI4+IH7lSgV2qRqQNUo3sLvmfK1O2s5
Snw6AfB/LmJS8vEhPJMjJ5NCn61xbG1rv3fsw4tZk9Yct71nEsOs8bD/VkLAme7o
BnGwcTZg2BTmymWiaK86puMJ++mFM/ksV2gIDybSak0d3u8EiFn+S23yWDqciUiX
mwLsiHKSX1D5LOMnNDtpN8bTo8OGvYshrGVKLBbfRbsCUinJKflU25ylJTmT2+Td
cWIqR8fQV+j3SnoVHTd3JGOArsNg34Duls19C+6UV7cWxbW/girLx85BvSxF+ALK
fpvEa9ORRvXGZ/l4hbvmGSIZ9VcK74Cun9E68OXqtVlNG2NpLtBRpCtdQSGf1Ku4
Ra/PpueRI3k=
=dwRW
-----END PGP SIGNATURE-----

--Sig_/IbC++g39c_kd7Z=HCc1QbaS--
