From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 - RMW logic
Date: Thu, 31 Jul 2014 07:30:07 +1000
Message-ID: <20140731073007.3fe4817a@notabene.brown>
References: <12EF8D94C6F8734FB2FF37B9FBEDD17358639B87@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/3T4/xd.nY2KNmyBxaW6DTgl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD17358639B87@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/3T4/xd.nY2KNmyBxaW6DTgl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jul 2014 20:24:30 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> Hi,
>=20
> the last days I tried to understand the RAID6 logic when recalculating
> P/Q parity (or syndrome) if only parts of a stripe are updated. As far
> as I get the current implementation right it will always read the whole
> stripe and build parities from scratch. E.g. updating a single chunk
> on a 10 disk RAID6 will read the other 7 data blocks to write the block
> plus 2 P/Q parities afterwards. Compared to the best case 3 read plus
> 3 write operations this can be quite a heavy impact. RAID5 at least
> has a shortcut for that.
>=20
> Being no specialist at all - but having some ideas - I would like to
> get some feedback about the following way to improve the scenario.
>=20
> 1) Write a modified gen_syndrome function (call it xor_syndrome)
> like in lib/raid6/xxx.c that allows to XOR an existing P/Q parity
> without overwriting it. The cost of that function would be the same
> as it only changes a few assembler commands.
>=20
> 2) Enhance the ops_run_prexor to call this xor_syndrome function
> for an RAID6. Fill the not relevant pages (R5_wantdrain) with an
> empty page or NULL. So the gen_syndrome will only find zeroes.
> With this call P/Q will have a pre-xored version.
>=20
> 3) Enhance ops_run_reconstruct6 to allow processing of changed
> blocks only. We will call xor_snydrome from there too, to XOR
> the prexored P/Q once again.
>=20
> 4) Enhance handle_stripe_dirtying so it will allow calculation of
> RCW versus RMW costs for the RAID6 case.
>=20
> Did I miss something? And if not: Will the doubled CPU consumption=20
> for P/Q calculation justify that way of implementation? At least
> we can avoid IOs on slow disks.
>=20
> Maybe it has been discussed before but I did not find it on the
> mailing list.
>=20
> Thanks in advance.
>=20
> Markus

Please see
  http://comments.gmane.org/gmane.linux.raid/42559

Yes, this is something we probably want.
The previous effort stalled somehow.  Maybe it just needs someone to start
pushing again.

NeilBrown

--Sig_/3T4/xd.nY2KNmyBxaW6DTgl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9lj3znsnt1WYoG5AQId9Q/+IMdZ9cQfSxBsYhnZyG9uAGQTjmKO7W1X
/kRZBNvL1CBjoEKfIln7hurgBfmCnRBtnJVJAat3Ve20gobQqR9OntWl9bciQS3b
Z6WyWQXYAuK7wvPUix3SWq3japV2IHJSYCgH/A2FbNElAL8kSVC0P0JBt0IkGBIH
eRROfWZ/pBuq/tx3dTH+oo/yLXa7QV2rr+TSE6V2HDYvrFXjfOpPKafMPJGg3+Os
xw2GEeARKXr5I6MTtU7x1w3XVgRSsJ9Kjo7l9bk8yCxKB6SUCK5rfM61wHsFIUxG
DN0PR1ZYL4VCUgy+sD5dQahOwJ7ALW7O8+tMkeKGBP2m1DhjazjJTu/vBpv+CeYY
YLC3RvsuuI+0h8vrkk8qCw3SP/WhwWDBb+6TbNjHeaiWH7kRLKalwylgHcwX8mn6
rMCbMrb2u6r9nmMZ1RcBe3s8y1Q5fnQFgF4JwwC1nq/qs+QqWFQycRfrR3JLsFGN
ZzRKqDj8FiygWUZ4q86PKWLzPibtvZjXO0DcajXEKgrJK+t29JzvBnio8msm2Lod
ht9f13kD34NMd0DGTnkwji3yHBIVWGzgaOa3nC9oQweTukYYBMmNCxSEngpieYlP
bBEhzZXLkgcWAqyhf0FIrWhEnsJhdYzdT5Uo9QnpdxDSVovYR5J/J7Xmtgz/Rrpk
E9fUX4tZJ54=
=xQH0
-----END PGP SIGNATURE-----

--Sig_/3T4/xd.nY2KNmyBxaW6DTgl--
