From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/5] imsm: support for OROMs shared by multiple HBAs
Date: Tue, 25 Nov 2014 11:51:54 +1100
Message-ID: <20141125115154.4cb8a415@notabene.brown>
References: <1416401610-16209-1-git-send-email-artur.paszkiewicz@intel.com>
	<1416401610-16209-2-git-send-email-artur.paszkiewicz@intel.com>
	<20141120140748.6daa763a@notabene.brown>
	<546E29CB.1010408@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/DhlFyvXh3cabaCsO9I39Vl9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <546E29CB.1010408@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--Sig_/DhlFyvXh3cabaCsO9I39Vl9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Nov 2014 18:50:03 +0100 Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:

> On 11/20/2014 04:07 AM, NeilBrown wrote:
> > On Wed, 19 Nov 2014 13:53:26 +0100 Artur Paszkiewicz
> > <artur.paszkiewicz@intel.com> wrote:
> >=20
> >> HBAs can share OROMs (e.g. SATA/sSATA). They are matched by PCI device
> >> id. Removed populated_orom/efi and imsm_orom/efi arrays - they are
> >> replaced by oroms array and functions get_orom_by_device_id(),
> >> add_orom(), add_orom_device_id().
> >>
> >> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> >=20
> > Hi,
> >  this patch seems to make a lot more changes that the above brief descr=
iption
> >  seems to suggest.
> >  Is there any chance of breaking it up into two or three parts, or at l=
east
> >  describing everything that is being changed.
> >=20
> >  I'm half tempted to just accept it as it is, as it is just "your" code=
 that
> >  that is being changed, but I'd like to understand it if I can.
> >=20
> > Thanks,
> > NeilBrown
> >=20
>=20
> Hi Neil,
>=20
> Splitting this up reasonably turned out to be more difficult than I
> thought, so I'll try to provide a more detailed description of the
> changes.=20
>=20
> The IMSM platform code was based on an assumption that the OROM or UEFI
> capability structure (represented by struct imsm_orom) always belongs to
> only one HBA. This assumption is no longer valid, because of newer
> platforms with dual AHCI HBAs. Each HBA can have a separate OROM, but
> some versions have a combined OROM for both HBAs.
>=20
> This patch implements this HBA-OROM relationship in struct orom_entry,
> which matches an OROM with a list of HBA PCI ids. All the detected
> orom_entries are stored and retrieved using a global array and the
> functions add_orom(), add_orom_device_id() and get_orom_by_device_id().
> This replaces the arrays: imsm_orom, populated_orom, imsm_efi,
> populated_efi.
>=20
> The scan() function is extended to find all HBAs for an OROM. The list
> of their device ids is retrieved from the PCI Expansion ROM Data
> Structure, hence the additional field devListOffset in struct
> pciExpDataStructFormat.
>=20
> In UEFI mode we can't read the PCI Expansion ROM Data Structure and the
> imsm_orom structures are stored in UEFI variables. They do not provide a
> similar device id list, so we also check the HBA PCI class to make sure
> that the HBA has RAID mode enabled.
>=20
> In super-intel.c there are changes which allow spanning of IMSM
> containers over HBAs of the same type, but only if the HBAs share the
> same OROM.  This is done by comparing imsm_orom pointers, which (outside
> of platform-intel.c) always point to the global array containing all the
> detected oroms. Additional warnings are added to
> validate_container_imsm() to warn about potentially dangerous operations
> in all the possible cases, e.g. when an array is assembled using disks
> attached to HBAs with separate OROMs.
>=20
> I hope you find this description helpful and that it will make the
> changes easier to understand.
>=20

Much better - thanks!

I've applied all 5 patches - using v2 of patch 4, and this comment for patch
1.

Thanks,
NeilBrown


--Sig_/DhlFyvXh3cabaCsO9I39Vl9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHPSqjnsnt1WYoG5AQJnzQ//dd5vN8hMcV2fKXJsfUyor+xoDAQAkS1L
GfOEbnskmMJjVzvrW8ZNEkXKPtAeMP/bFE7s7aFGxi9lDfvpEwg2VjTxXAEvnJEs
8YrTwuXe6OtW5kXhNROSdmlDygIRYePDV9zJ7xmK2sdnk8Sp4QnJIX2mIkNDVEhT
Zy1Qksb+/CmR7QcmURmoolLPa+KWeut/fb6oAhawQlq/faCt0pY/58eEc9v/1HBs
R9+KpCO5wKWxYE9Yt7GVJVNdDCjkIwjsWc6Lr+zz04kkUP22TzZDSd11rXEzQ6MT
OwxnSmO3aLY76NfIDyf+9ey7/zyT4IF8Q+SEPqe2XN3O9F+BXn9e3jvLgPbSnEYm
dN3gH4hA4Et0KI/LNHqyzVUVWZ7Lq/olNvAvpShB8Gv0wd5unj4RVchz9Z5so/8l
We6xM8vTxYiXDXN4CeU3OMAnoP0+OcSy/AAxkFI+09wIb8tvWM1OIs5i32OfXzHS
zCmVDJISeYV8ax9dNc7i1zyvg7MQd5I+M8Vc0o02t/OnfA7R94XB/1JegAfAAjX/
CyIrQ8ZqNT3Gw2VP1zC6ePSMmi2Fmp3ZTgXp3R/MxREAMzWMUszQY9bfZyCIMmbi
Aw5TUr4oiT43uGul3xtxzm6CWCbPNwQIKYH1vpjmX+y2rDdYASxoTzS5jiOQN/ED
E/LfI6UFFms=
=fzc4
-----END PGP SIGNATURE-----

--Sig_/DhlFyvXh3cabaCsO9I39Vl9--
