From: NeilBrown <neilb@suse.de>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Mon, 13 Jan 2014 20:45:34 +1100
Message-ID: <20140113204534.737a98f6@notabene.brown>
References: <52BD8EDD.10809@assyoma.it>
	<20131227151927.GA4003@www5.open-std.org>
	<52BD9B4F.3000509@assyoma.it>
	<20131227154952.GA6539@www5.open-std.org>
	<52CE57D9.1030501@assyoma.it>
	<20140113102021.1ef3e203@notabene.brown>
	<52D3A962.4000308@assyoma.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Bgau4uCJ5iLx4=YlLPhQ/OK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52D3A962.4000308@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-raid@vger.kernel.org, keld@keldix.com
List-Id: linux-raid.ids

--Sig_/Bgau4uCJ5iLx4=YlLPhQ/OK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jan 2014 09:52:50 +0100 Gionatan Danti <g.danti@assyoma.it> wrot=
e:

> Hi Neil,
> let me recap from a previous message:
>=20
>  >FAR LAYOUT
>  >md(4) states:
>  >"The first copy of all data blocks will be striped across the early >pa=
rt
>  >of all drives in RAID0 fashion, and then the next copy of all blocks
>  >will be striped across a later section of all drives, always ensuring
>  >that all copies of any given block are on different drives"
>  >
>  >The "on different drives" part let me wonder _how_ are chunks
>  >distributed. On a 4-disk array, I can imagine some different schemas:
>  >
>  >1)	A1 A2 A3 A4
>  >	.. .. .. ..
>  >	A4 A1 A2 A3
>  >
>  >2)	A1 A2 A3 A4
>  >	.. .. .. ..
>  >	A2 A1 A4 A3
>  >
>  >The first schema is the one depicted by SuSe documentation [1], while
>  >the second is the one described by Wikipedia [2].
>  >
>  >Question 1: as the two schema have different reliability
>  >characteristics, which is really used?
>=20
> SuSe entry:=20
> https://www.suse.com/documentation/sles11/stor_admin/data/raidmdadmr10cpx=
.html#b7cynnk
>=20
> Wikipedia entry:=20
> http://en.wikipedia.org/wiki/Linux_MD_RAID_10#LINUX-MD-RAID-10 (see how=20
> far layout is depicted)
>=20
> Keld kindly told me that the SuSe is simply not updated, as it depict a=20
> situation changed with newer kernels. So my two questions:

I cannot see an important difference between the two pages you reference.
Both appear to be correct.

> 1) from which kernel the layout is the one depicted by Wikipedia?

These are both valid for any kernel since 2.6.18 with mdadm 2.5 or later.

> 2) it is possible, using mdadm, check what "far" layout is in use?

I think I know what you are talking about now.  The md driver in the kernel
supports two sorts of 'far' or 'offset' layouts for arrays where the number
of devices is not an integer multiple of the number of copies.
This has been supported in Linux since v3.9. but is not yet supported by
mdadm.

>=20
>  From what I can see, a "mdadm --detail /dev/mdWHATEVER | grep Layout"=20
> tell me if using far vs near vs offset layout, but not the physical=20
> on-disk chunks organization (eg: far "type" 1 or 2).

This is because mdadm does not yet create or report on the new type.
When it does, the above command will be the correct command to find out whi=
ch
layout is in use (but I don't yet know what the output will say exactly).

NeilBrown


>=20
> Anyway, the thread started because I wonder why the OFFSET layout couple=
=20
> each disk to other two disks. Let me quote again:
>=20
>  >OFFSET LAYOUT
>  >md(4) states:
>  >"When 'offset' replicas are chosen, the multiple copies of a given >chu=
nk
>  >are laid out on consecutive drives and at consecutive offsets.
>  >Effectively each stripe is duplicated and the copies are offset by one
>  >device."
>  >
>  >This means a schema like this:
>  >=09
>  >3)	A1 A2 A3 A4
>  >	A4 A1 A2 A3
>  >	.. .. .. ..
>  >
>  >However, this is susceptible to any consecutive two-disk failures. A
>  >schema like
>  >
>  >4)	A1 A2 A3 A4
>  >	A2 A1 A4 A3
>  >
>  >would not suffer from this problem (eg: disk 2 & 3 can fail and the
>  >array is still working).
>  >
>  >Question 2: apart from simplicity, why the offset layout use the schema
>  >as n.3? I miss something?
>=20
> Full thread link: http://marc.info/?t=3D138815504400002&r=3D1&w=3D2
>=20
> Excuse me for the long email, I am simply trying to learn something :)
> Thank you very much.
>=20
> On 01/13/2014 12:20 AM, NeilBrown wrote:
> > On Thu, 09 Jan 2014 09:03:37 +0100 Gionatan Danti <g.danti@assyoma.it> =
wrote:
> >
> >>>>
> >>>> Interesting. Two question:
> >>>> 1) from which kernel the layout is the one depicted by Wikipedia?
> >
> > Exactly what depiction in wikipedia are you referring to?  A link to the
> > image might help.
> >
> >>>> 2) it is possible, using mdadm, check what "far" layout is in use?
> >
> > mdadm --detail /dev/mdWHATEVER | grep Layout
> >
> >
> >>>
> >>> I cannot answer that. Neil Brown should know.
> >>>
> >>> Best regards
> >>> Keld
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>
> >> Hi all,
> >> anyone with an update on these two questions?
> >>
> >> I was thinking to use the kernel block trace facility to track disk
> >> access and infer the on-disk data structure, but I haven't tried for n=
ow.
> >>
> >> On the other hand, I carefully looked at mdadm output, without finding
> >> anything related to physical block placing.
> >
> > Look for "Layout".
> >
> > NeilBrown
> >
> >
> >>
> >> Any new advices on that regard?
> >> Thanks.
> >>
> >
>=20


--Sig_/Bgau4uCJ5iLx4=YlLPhQ/OK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtO1vjnsnt1WYoG5AQL3lQ/9EFQYRj5fgtW50M2+9fJyfWGwLVmUFAmb
7H/Gp2ygV+bZhldSJxul8J4eENpW43Mpe27nTikkimbDaLNQ51zqnQsGSak2tN8e
dxR56uV2FXIwiKkz9IuuTMhJrnp1/WaNv889c3ujpUGm7FGltykpMbLO1c/u9yZs
/o6vuka77tBhAl+BbVzuz4m3BOE70jrkZsBtzspN0+30/8mbwMgqcB3Yz+oFECbJ
x8mdNMDDy0UE5dyIFURfnuOBY8eBlR7lwMWJeRWaRr2paHE2uq5OF/2DzEt/7hkW
M7e/9JMyPVQqfPBpVvQg8JoiNFcb5Q+adVQflYljzsnOhmuZ/1CMFos21xcx1Suh
AMLRuXG9BuDpU75g+MbTGxBbr39mH79hojWYfERB6IgNak7pkYRQHf28ZZosg//b
+mAipxl9ls4D2g+La3NquskFAsNDAUPMBoz3utho4+QxRfg5fVTVik/Ce89xnI10
tx8BiKE4ThK9Hab1MMHZZ3Bdyx/LgTy3/yU164YKSD7jQ9QmUpHEMLgOAMXN0lve
AAtr+KhbGaLix07N5upz6aTag1fiWx5ctD5EC6anQzJ/W/ruoAwv5zx8vK9Wjtrv
WhfTkVEYglfdVZx5+A+tscGR7n7XhSYyqB0AQsF60j0kdQ5WC3oZwzgq12GpLsVn
9i5vOh9Z0RE=
=1UnA
-----END PGP SIGNATURE-----

--Sig_/Bgau4uCJ5iLx4=YlLPhQ/OK--
