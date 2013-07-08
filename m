From: NeilBrown <neilb@suse.de>
Subject: Re: DDF/RAID10 patch series
Date: Mon, 8 Jul 2013 16:53:14 +1000
Message-ID: <20130708165314.1e400134@notabene.brown>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8CI=F.jJ=xHB6Mr8Q5nAs66"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8CI=F.jJ=xHB6Mr8Q5nAs66
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  3 Jul 2013 22:27:40 +0200 mwilck@arcor.de wrote:

> This is the DDF/RAID10 patch series I announced.
>=20
> The whole patch set is aimed at making --Create work with DDF/RAID10.
> When --Create eventually works, RAID10 can be added to the DDF
> regression test.
>=20
> With this patch set, DDF is still far from the level of functionality
> present in IMSM, but getting a little closer.
>=20
> The patch set also includes some cleanup patches and debug code which
> I needed to find the bugs in earlier versions, and which might be useful
> later as well.
>=20
> Please review and test.
>=20
> Regards
> Martin
>=20
> Martin Wilck (27):
>   DDF (cleanup): use a common macro for failed searches
>   DDF: check_secondary: fix treatment of missing BVDs
>   DDF: load_ddf_headers: use secondary header as fallback
>   DDF: handle "open flag" according to spec
>   DDF: Implement store_super_ddf
>   DDF: ddf_open_new: implement minimal consistency check
>   DDF: find_vdcr: account for secondary RAID level
>   DDF: ddf_set_disk: move status logic to separate function
>   DDF: get_svd_state: Status logic for secondary RAID level
>   DDF: allow empty slots in virt disk table
>   DDF: layout_ddf2md: new DDF->md RAID layout conversion
>   DDF: layout_md2ddf: new md->DDF layout conversion
>   DDF: Simplify allocation of "other BVDs"
>   DDF: init_super_ddf_bvd: initialize other bvds
>   DDF: validate_geometry_ddf: support RAID10
>   DDF: use LBA_OFFSET macro instead of lba_offset field
>   DDF: get_extents: support secondary RAID level
>   DDF: add_to_super_ddf: allow empty slots in phys disk table
>   DDF: add_to_super_ddf: Use same amount of workspace as other disks
>   DDF: add_to_super_ddf: RAID10 changes
>   DDF: add_to_super_ddf_bvd: use get_svd_state()
>   DDF: getinfo_super_ddf_bvd: lba_offset calculation for RAID10
>   DDF: guid_str: convenience function to print GUID for debugging
>   DDF: ddf_set_array_state: more meaningful output
>   DDF: ddf_process_update: handle update of conf records for SVD
>   DDF: ddf_process_update: Fix vlist treatment for SVDs
>   tests/10ddf-create: add RAID 10 array
>=20
>  super-ddf.c        | 1134 +++++++++++++++++++++++++++++++++-------------=
------
>  tests/10ddf-create |   15 +-
>  2 files changed, 739 insertions(+), 410 deletions(-)


Thanks. I've applied all these (with the changes that I have already
mentioned and a couple of other  tiny things).
I'll do some testing too at some stage.

NeilBrown

--Sig_/8CI=F.jJ=xHB6Mr8Q5nAs66
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdph2jnsnt1WYoG5AQKmPRAAqdLVoZMGNUt1KobJQkVXzmHNeDRtvEaB
ueRH7M04PGByWYMeqQOfvE/4C16TvbzzYn7dkLcetb/zKFVssi0wBHyS6IN8kJpq
QTxviJyyOD5kdOrvv5+DW5oLa+N+v80cuOgfa55m4YqIS/XhBeawSb/4ElUMAiX+
Zxbf726+BsfhdhA5BK9r5hicNHl6l5J8lY9jAt3/CJT7GzQWTcBJ5IWwZiC2lC+v
GdLG6ho7aRdb7U39iOsBPj+kYDRWzp6P+8zSpu8lnuLgGITknCqvXqUitNkKkfVh
NeVcX5ziUMNccbjgMG2PFs5n8jRFdgAKQ0tlGe6BtKha1X1Aa1wEMe+naSZeLYV9
5njr69NIWhG+fC70+9Ulrz6SCUR4ljLcAZ4PRL5NvpR5weNpfwoDV6PK85wW8BF6
oS7PyQ+CE/UyPr5CHLsPo6R7N95aN1sdZeIRTXvaAStoFfqhqYyJs07cdrs1KOCj
rsVCS35hGjc5nstI9xPBdH7OgAogEOdKf7YEX2JlhwJnhI+R5/omDhuVFFRYMvKR
Rj6U48Ay6BWWZf+/0L1aJ2DvcmT3ItdxWAKbx9J3easkJKXk12FyFhwMI35gWnSI
ZsuKSNUBOvBs2FMBCYuCCXkH5H/jcQWwgPTPWwRS9XXTz3sTaFUJyN9WQB/H/kHb
aE685/RE7Zo=
=ZiMg
-----END PGP SIGNATURE-----

--Sig_/8CI=F.jJ=xHB6Mr8Q5nAs66--
