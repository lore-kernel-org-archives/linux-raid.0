From: Jakob Oestergaard <jakob@unthought.net>
Subject: Re: raidreconf: Successful RAID5 Reconstruction (re-size)
Date: Wed, 26 Jun 2002 20:02:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020626180209.GB4914@unthought.net>
References: <NDBBIAKEEKGGEIKCBKNAAEOGDAAA.kc130iseo@coastalnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <NDBBIAKEEKGGEIKCBKNAAEOGDAAA.kc130iseo@coastalnet.com>
To: cwebster@axl.iseocp.navy.mil
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 26, 2002 at 10:41:07AM -0600, Cal Webster wrote:
> As requested in the documentation, this message is to provide feedbac=
k on
> use of "raidreconf". See below for "System Profile".

Thanks !

>=20
> The total time required to reconstruct our RAID5 was less than 6 hour=
s.
> There were no errors. Prior to the reconfiguration, a backup from the=
 RAID
> to the 80 GB IDE drive took approximately 5 hours with maximum compre=
ssion.
> See "Actions Taken" below for details on what done to accomplish this=
 task.

Ok, cool.

=2E..
> Although the reconstruction was completely successful and seemed to b=
e
> pretty efficient, I think we are going to "re-make" the array anyway.=
 I
> would like the arrays to be constructed with the fixes and enhancemen=
ts of
> the latest raidtools. I would also like to at least start out with a =
RAID
> configuration that was specified, where the spare is the last drive. =
I'm not
> sure exactly what difference there will be between the 0.90 and 1.00 =
devices
> in terms of efficiency, but I'm assuming there were fixes and enhance=
ments
> from which the RAID would benefit.

The layout of the RAID is dictated by the kernel. The raidtools (except
for raidreconf which works directly on the array components) are simply
an interface to the RAID code.

Therefore, there is no change in RAID layout between raidtools 0.90 and
1.0.

> The original array was created with raidtools version 0.90. As expect=
ed, the
> superblocks for the original 6 drives attest to this (see below). How=
ever, I
> was surprised to see that the superblocks of the newly added drives d=
id not
> display the current version (raidtools-1.00.2-1.3).

No change - the kernel RAID code is probably still called 0.90  :)

> One other thing is puzzling me. When I constructed the new "raidtab" =
I
> explicitly reconfigured the array so that all devices would be in seq=
uence,
> leaving the last drive as the spare. Disregarding my "new" raidtab,
> "raidreconf" kept the old spare (/dev/sdc) and used the last drive in=
 the
> array in its place. So, now the sequence of devices is incorrect.
>=20
> Old sequence:     sda sdb sdf sdd sde sdc
> RAID Drive #:      0   1   2   3   4   S
>=20
> Desired sequence: sda sdb sdc sdd sde sdf sdg sdh sdi
> RAID Drive #:      0   1   2   3   4   5   6   7   S
>=20
> Sequence created: sda sdb sdi sdd sde sdf sdg sdh sdc
> RAID Drive #:      0   1   2   3   4   5   6   7   S

This could be a raidreconf bug, I have never tested it with spares
myself...

> CPU:
>=20
> cpu		: TI UltraSparc IIi
> fpu		: UltraSparc IIi integrated FPU
> promlib		: Version 3 Revision 14
> prom		: 3.14.0
> type		: sun4u
> ncpus probed	: 1
> ncpus active	: 1
> Cpu0Bogo	: 599.65
> Cpu0ClkTck	: 0000000011e1ab1e
> MMU Type	: Spitfire
>=20
> Physical RAM:	256 MB
>=20

I have never tested raidreconf on anything but ia32 - thanks a lot for
this information !    :)

=2E..
> Using 128 Kbyte blocks to move from 128 Kbyte chunks to 128 Kbyte chu=
nks.
> Detected 254584 KB of physical memory in system

I think that some people are seeing problems with the memory detection,
but it seems like it worked in your case - even on a Sun,  great !

=2E..
> Maximum friend-freeing depth:         8
> Total wishes hooked:             690690
> Maximum wishes hooked:              517
> Total gifts hooked:              690690
> Maximum gifts hooked:               415

These statistics, especially the friend-freeing depth are *really*
valuable to me.

I saw your other mail as well and will comment... Hang on.  Thanks a lo=
t
for this thorough feedback, it is really essential for any improvements
to happen.

--=20
=2E...............................................................
:   jakob@unthought.net   : And I see the elder races,         :
:.........................: putrid forms of man                :
:   Jakob =D8stergaard      : See him rise and claim the earth,  :
:        OZ9ABN           : his downfall is at hand.           :
:.........................:............{Konkhra}...............:
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
