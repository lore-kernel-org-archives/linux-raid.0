From: NeilBrown <neilb@suse.de>
Subject: Re: sb->resync_offset value after resync failure
Date: Thu, 26 Jan 2012 11:51:32 +1100
Message-ID: <20120126115132.75d9d8bd@notabene.brown>
References: <CAGRgLy44uKSggEsrU4Fx7op7iVjoPPq-doMdYjxnSGDm6krf9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ArI2OTDwz6B3YnDBeNaeqpS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy44uKSggEsrU4Fx7op7iVjoPPq-doMdYjxnSGDm6krf9A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ArI2OTDwz6B3YnDBeNaeqpS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jan 2012 18:19:55 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Greetings,
> I am looking into a scenario, in which the md raid5/6 array is
> resyncing (e.g., after a fresh creation) and there is a drive failure.
> As written in Neil's blog entry "Closing the RAID5 write hole"
> (http://neil.brown.name/blog/20110614101708): "if a device fails
> during the resync, md doesn't take special action - it just allows the
> array to be used without a resync even though there could be corrupt
> data".
>=20
> However, I noticed that at this point sb->resync_offset in the
> superblock is not set to MaxSector. At this point if a drive is
> added/re-added to the array, then drive recovery starts, i.e., md
> assumes that data/parity on the surviving drives are correct, and uses
> them to rebuild the new drive. This state of data/parity being correct
> should be reflected as sb->resync_offset=3D=3DMaxSector, shouldn't it?
>=20
> One issue that I ran into is the following: I reached a situation in
> which during array assembly: sb->resync_offset=3D=3Dsb->size. At this
> point, the following code in mdadm
> assumes that array is clean:
> info->array.state =3D
>     (__le64_to_cpu(sb->resync_offset) >=3D __le64_to_cpu(sb->size))
>  =C2=A0=C2=A0=C2=A0 ? 1 : 0;
> As a result, mdadm lets the array assembly flow through fine to the
> kernel, but in the kernel the following code refuses to start the
> array:
> =C2=A0=C2=A0=C2=A0 if (mddev->degraded > dirty_parity_disks &&
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 mddev->recovery_cp !=3D MaxSector) {
>=20
> At this point, speciying --force to mdadm --assembly doesn't help,
> because mdadm thinks that array is clean (clean=3D=3D1), and therefore
> doesn't do the "force-array" update, which would knock off the
> sb->resync_offset value. So there is no way to start the array, unless
> specifying the start_dirty_degraded=3D1 kernel parameter.
>=20
> So one question is: should mdadm compare sb->resync_offset to
> MaxSector and not to sb->size? In the kernel code, resync_offset is
> always compared to MaxSector.

Yes, mdadm should be consistent with the kernel.  Patches welcome.

>=20
> Another question is: whether sb->resync_offset should be set to
> MaxSector by the kernel as soon as it starts rebuilding a drive? I
> think this would be consistent with what Neil wrote in the blog entry.

Maybe every time we update ->curr_resync_completed we should update
->recovery_cp as well if it is below the new ->curre_resync_completed ??


>=20
> Here is the scenario to reproduce the issue I described:
> # Create a raid6 array with 4 drives A,B,C,D. Array starts resyncing.
> # Fail drive D. Array aborts the resync and then immediately restarts
> it (it seems to checkpoint the mddev->recovery_cp, but I am not sure
> that it restarts from that checkpoint)
> # Re-add drive D to the array. It is added as a spare, array continues re=
syncing
> # Fail drive C. Array aborts the resync, and then starts rebuilding
> drive D. At this point sb->resync_offset is some valid value (usually
> 0, not MaxSectors and not sb->size).

Does it start the rebuilding from the start?  I hope it does.

> # Stop the array. At this point sb->resync offset is sb->size in all
> the superblocks.

At some point in there you had a RAID6 with two missing devices, so it is
either failed or completely in-sync.  I guess we assume the latter.
Is that wrong?

>=20
> Another question I have: when exactly md decides to update the
> sb->resync_offset in the superblock? I am playing with similar
> scenarios with raid5, and sometimes I end up with MaxSectors and
> sometimes with valid values. From the code, it looks like only this
> logic updates it:
> 	if (mddev->in_sync)
> 		sb->resync_offset =3D cpu_to_le64(mddev->recovery_cp);
> 	else
> 		sb->resync_offset =3D cpu_to_le64(0);
> except for resizing and setting through sysfs. But I don't understand
> how this value should be managed in general.

I'm not sure what you are asking here .... that code explains exactly when
resync_offset should be set, and how.
What more is there to say?

NeilBrown


>=20
> Thanks!
> Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/ArI2OTDwz6B3YnDBeNaeqpS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyCjlDnsnt1WYoG5AQLfSg//dCb0m3BAAmIlpanzT100HA7XmxI+OrAq
sCAnRwC2UpTrjYbNPmdildQ4OqGcFe1aGN8VoXdiNjLZ/SsY/mZx33X3Qn0gOncn
qbRD2+OPfeytEaVA0BcI6weFkJmSSM0+U6buabGxkglPBw0n3grhujwkKasuMION
aem0vlAfPChEzVbDOmApfA3tO0FB/tWpJuVlnbVFDHHU1XzwH+6yIpCOCfhO8Jsb
psOCPn/2VegTtzC64ruBp6ZntfeRql16QATGDxN1gS2Lsm7BwJLV2o+UibPkUHjU
KZc1YYZJQWmiB/fwFle55HxGqe/qARX2/set2yWGQecBRnNP/9dppa4pWHuF3D1e
HjcKEVXQxLS6GXnubuQ1v6IRqVgEYv8kT4ODkr+T+tkZIQWZ3rqoCJWLffirZhxu
rb3q2rLeC17AIeT3bKXBQYENLX2MlmVxg00rNj4xigCNpnxkFUomxicAYAdbmjJ4
5KeCiRX78ABxrmhIexz7BwNr1kM3vpXSgW86lRJps3pfbe1MQ/B0RwtK8xiC8YWv
rs1uWrcdxidrSW+nF9XBBsDH6GIv9yIl6nl+kHw0C8vnuwPMyf7LjWTQrIge6btY
4/vqPxuWqmCt+FbADq4IiIa0PTGZVJ33Ny+56SXvtuRuiSxulHhXOn1IqH/V2hkV
eb/IghZDSLc=
=ruVB
-----END PGP SIGNATURE-----

--Sig_/ArI2OTDwz6B3YnDBeNaeqpS--
