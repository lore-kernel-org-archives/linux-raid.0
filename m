From: NeilBrown <neilb@suse.de>
Subject: Re: How to use --freeze-reshape  and is it safe?
Date: Thu, 14 Aug 2014 17:30:57 +1000
Message-ID: <20140814173057.3913f5e1@notabene.brown>
References: <53EC4B63.90703@gmail.com>
	<20140814155633.567baece@notabene.brown>
	<53EC5658.3050708@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/gNnMdS9=YkU5KInd+ERLG4Z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53EC5658.3050708@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/gNnMdS9=YkU5KInd+ERLG4Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Aug 2014 01:25:28 -0500 Ram Ramesh <rramesh2400@gmail.com> wrote:

> On 08/14/2014 12:56 AM, NeilBrown wrote:
> > On Thu, 14 Aug 2014 00:38:43 -0500 Ram Ramesh <rramesh2400@gmail.com> w=
rote:
> >
> >> I was browsing through mdadm man pages to check out --layout options
> >> when converting 3disk-raid5 to 4disk-raid6 and encountered
> >> --freeze-reshape switch/arg. I did a quick google and could not get mu=
ch
> >> info. Can a user issue this to suspend reshape for a short while?
> > As --freeze-reshape is only meaningful in combination with --assemble,
> > this question doesn't really make sense.
> >
> > If you are using a sufficiently new kernel and mdadm so that "data_offs=
et" is
> > adjusted during reshapes so that no 'backup' is needed, then you can
> > suspend a reshape for a period of time by:
> >
> >    echo frozen > /sys/block/mdXXX/md/sync_action
> >
> > This is perfectly safe.  When you want to unfreeze, write 'idle'
> > to 'sync_action'.  md will notice that a reshape is pending and will re=
start
> > where it was up to.
> >
> >
> >> Specifically
> >>
> >>   1. Is the use (or frequent use) of this switch safe? recommended?
> >>   2. Can the array be mounted when this switch is used?
> >>   3. What is correct syntax for the usage?
> >>   4. Can I use this to manage the reshape load on an array? May be to =
let
> >>      the disk cool off after a busy hours of seeking to reshape?
> >>   5. Can I use it as a safe method for shutting down  the machine?
> >>   6. Is there a tutorial/faq/manual that explains in detail the use of
> >>      other mdadm esoteric switches? (like --layout I was searching)
> > Is it really that esoteric?
> > If you want to reshape an array, you run "mdadm --grow" and list all the
> > changes you want to make.  Set a new level, a new number of devices, a =
new
> > layout, a new chunk size, whatever.  mdadm will do it if it can and giv=
e an
> > error if it cannot.
> > If you want to test it out first then that is extremely sensible.  Make=
 some
> > loop devices and experiment.
> >
> > NeilBrown
> Thanks. The name --freeze-reshape mislead me in to thinking that this is=
=20
> a request to stop reshape just like -fail is to make a drive
> failed. I used esoteric to mean not routinely used or cannot be=20
> interpreted by plain English meaning of the the switch/arg name.
>=20
> While I am at this, let me ask the --layout question also. Does=20
> conversion from raid5 to raid6 do --layout=3Dleft-symmeric-6 first and=20
> then distribute Q through second pass with --layout=3Dleft-symmetric? If=
=20
> not, will the reshape be faster if I did it in two phases?

When you convert a raid5 to a raid6 it will assume that an extra drive is
being added as well.
Firstly the array is instantaneously converted from an optimal RAID5 in
left-symmetric layout to a degraded RAID6 in left-symmetric-6 layout.

Then the reshape process is started which reads each stripe in the
left-symmetric-6 layout and writes it back in the raid6:left-symmetric layo=
ut.

(if you specify a different number of final devices it all still works in o=
ne
pass, but the dance is more complex).

If this is done without changing the data offset, then every stripe is
written on top of the old location of the same stripe so if the host crashed
in the middle of the write, data would be lost.
So mdadm copies each stripe to a backup-file before allowing the data to be
relocated.  This causes a lot more IO than required to move the data, but is
a lot safer.

With newer kernels (v3.5) and mdadm (v3.3) a reshape can move the data_offs=
et
at the same time so that it is only ever writing to an unused area of the
devices.  This should be much faster.
However it requires that the data_offset is high enough that there is room =
to
move it backwards.  mdadm 3.3 creates arrays with a reasonably large
data_offset.  With arrays created earlier you might need to
 - shrink the filesystem
 - shrink the --size of the array

md can either increase or decrease the data offset.
The later requires free space at the start of the array so data_offset must
be large.  The former requires free space at the end of the array, so size
must be less than the maximum.  "mdadm --examine" will report "Unused space"
both "before" and "after" which indicates how much data_offset can be moved.
If either of these are larger than 1 chunk, then mdadm will make use of it.

To answer you question: there is no "second pass".  The only way to make it
faster is to have a recent kernel and mdadm and make sure there is sufficie=
nt
Unused space, either "before" or "after".

NeilBrown

--Sig_/gNnMdS9=YkU5KInd+ERLG4Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+xlsTnsnt1WYoG5AQIZoBAAhEGVO4l1oiztTx+sFfpj/3Lb9n8ts9sf
IuSc0GQgX1umAVS+OAQC9pZqGrab6zbKkgCHQ51vqd5UyfeCynUvSlzFwTD3GzjK
FfXOIaHkhUHO3nigAntOXSZI9ThfC/g0gjizTOe+xcPUfhz9AzEezm2DUiXNaxjQ
B7ftEZBZkScpZ0hcC1D4N8hgpwASy9V0ZtVSyQuKyLmAKJ8zHDUxrgJUbbhhHnwP
NS8iRqHjZx1yvsduznT/65xzmuhWJ3CSQrFQ4ivGD9n/m0eapvREyV04gd1WVTVO
46jDN3BtFNHIyk2rhOTCrVAab6EG5kz6iq0WW0PxMDeaHlSoEnSK1LgUBU3pgriN
96DVlkaal8xz5Nqotkb3S+R7tyh2+9eqoQBygeyi2A9sjTzwyOpGKGT0HCJJ0868
4cVNkdFG0SYE+0e37APZYr/4WI1C3FjAsrqgn33Jt/LlXQ/XdyZ8FzVlMm51zonW
S01Ea5l3Hwa4HkGtGW/VuZDpXehJMH+c+Ln+luaRmYmt2xksU3vZ6UHuVgZUkp73
Rt9MUcrx7WfIACjdRYr5HZt7xzZUzCLAF9Ktk6kLBfdOKKlOiCKv/stPU7kZSOGV
BD6pwjkwLlcwKB/pdkti+C39Ksj8fafAigdNWCKCpKG+UM90N6zNzh6Ax/CwlUwT
INEW2ORE2Yk=
=NxtF
-----END PGP SIGNATURE-----

--Sig_/gNnMdS9=YkU5KInd+ERLG4Z--
