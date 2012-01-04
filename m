From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] Don't tell sysfs to launch the container as we are
 doing it ourselves
Date: Wed, 4 Jan 2012 13:34:56 +1100
Message-ID: <20120104133456.5ac6a260@notabene.brown>
References: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>
	<1319204000-6661-3-git-send-email-Jes.Sorensen@redhat.com>
	<20111223104843.6ef30cba@notabene.brown>
	<4F02D76A.1010002@redhat.com>
	<4F0324C1.706@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BPp32Zu4HPh7ukdbCbRD4lJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0324C1.706@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com
List-Id: linux-raid.ids

--Sig_/BPp32Zu4HPh7ukdbCbRD4lJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Jan 2012 10:54:41 -0500 Doug Ledford <dledford@redhat.com> wrote:

> On 01/03/2012 05:24 AM, Jes Sorensen wrote:
> > On 12/23/11 00:48, NeilBrown wrote:
> >> On Fri, 21 Oct 2011 15:33:19 +0200 Jes.Sorensen@redhat.com wrote:
> >>
> >>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >>>
> >>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> >>> ---
> >>>  Incremental.c |    1 -
> >>>  1 files changed, 0 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/Incremental.c b/Incremental.c
> >>> index 1a9a97b..cff7663 100644
> >>> --- a/Incremental.c
> >>> +++ b/Incremental.c
> >>> @@ -446,7 +446,6 @@ int Incremental(char *devname, int verbose, int r=
unstop,
> >>>  	if (info.array.level =3D=3D LEVEL_CONTAINER) {
> >>>  		int devnum =3D devnum; /* defined and used iff ->external */
> >>>  		/* Try to assemble within the container */
> >>> -		sysfs_uevent(&info, "change");
> >>>  		if (verbose >=3D 0)
> >>>  			fprintf(stderr, Name
> >>>  				": container %s now has %d devices\n",
> >>
> >> Hi Jes,
> >>  I've had to revert this patch as it causes a regression.
> >>
> >> Without the 'change' event the container device doesn't get created in=
 /dev.
> >>
> >> I'm not sure udev should be running "--incremental" on containers anyw=
ay, but
> >> if it does it shouldn't cause problems should it?  If it does we shoul=
d fix
> >> those problems.
> >=20
> > Hi Neil,
> >=20
> > I am wary of this being reverted as it fixed a genuine race condition.
> > On Fedora we don't have the problem with the container device not being
> > created, could it be that your udev scripts are not doing the right
> > thing in this case?
>=20
> I think it's probably worthwhile for us to do a udev rules file
> comparison.  So, I'm attaching the patch we apply to the udev rules file
> in your distribution before installing it, as also the rules file that
> handles incremental assembly on Fedora/RHEL.  Look them over and see if
> you want to include any of the things we have there in your version.
>=20
> As to the question of udev running incremental on containers, I think
> it's fair to say that either udev or mdadm should be doing so, and not
> both.  Whether it should be one or the other is up for debate I think.
> Doing it in mdadm where this patch pulls it out means that it only
> happens on add of a new device using incremental assembly.  The udev
> version does it on a change event on the container.  The question I have
> is, if you had mdmon migrate a spare into a container, would it trigger
> this code in mdadm versus would it trigger the code in the udev rules
> file?  Is there any situation where a change triggered via something
> other than incremental assembly would result in us needing to run
> incremental on the container?  If the answer is yes, then I would
> recommend doing things in the udev file versus in the incremental
> function of mdadm.
>=20
>=20

Nothing's ever easy.....

I just tried to reproduce the problem I had which lead me to revert that
patch, but mdadm didn't behave as I expected.  So now I'm running my test
suite with the revert removed to see what happens.

However I think that if triggering a change event at that point (or at
any point) causes a problem, then the problem was already there and needs to
be fixed.  If there is a race as you say (and I suspect you are right) then
we need to put in appropriate locking to make sure the race doesn't cause a
problem. Just removing the code that triggers the race isn't really enough.

I think that *both* mdadm and udev should be trying to assemble the contents
of a container when the container changes.  I'm not convinced that everyone
will be running udev though most probably will.  Again: if this is racy we
should identify and lock-out the races.

I don't see how your 'migrate a spare' scenario is relevant but I've probab=
ly
missed something.
The scenarios we have been talking about are for assembling a device once a=
ll
the required components become available.  A 'spare' cannot possibly be a
required component so it doesn't seem relevant.
When a spare is migrated in, mdmon should notice and take whatever action is
necessary.  This is quite separate from mdadm or udev.

And I've found out the details of the regression.  It is another race :-(

It particularly affects DDF as DDF containers can have a name.

When you "mdadm -I /dev/thing" the first device in a DDF container it will
firstly "set_array_info" to set up the array, then add the info to the 'map'
file.

The set_array_info (or probably the "open" before that) will trigger the
"ADD" uevent which will run mdadm which should create the /dev/md/WHATEVER
link.
However if this happens before mdadm updates the 'map' file it won't be able
to create the link.

So we need to trigger a 'change' event after updating the map file.

There are probably other ways to fix this.  We could maybe update the map
file before creating the array device, but that feels clumsy - error handli=
ng
would be messy.

We could hold the mapfile locked from before creating the device to after
updating the map file.   Then make sure the mdadm that is run from udev wai=
ts
for the lock before looking for the name of the array.  That is probably
better.

In any case I think we need to give some serious thought to locking to avoid
races between different mdadm.  We have some in place already - just need to
make sure it is used consistently.


Some of the changes you have made to the udev.rules file look worth while.
Having two separate files is probably a good idea - one for devices which a=
re
array and one for devices which might be members of arrays.

The various options for skipping things look a bit painful.
i.e. we test for
  ANACONDA
  DM_MULTIPATH_DEVICE_PATH
  noiswmd
  nodmraid

The last two are probably OK.  The first two I would rather see something e=
lse
set a generic "Don't include this device in anything - I've got it
under control" setting, and then the mdadm rules file just checks that and
ignores as appropriate.

It would be good if everything in the rules file in the main distribution
were equally appropriate for all distros, and that any change a distro want=
ed
to make could be done in a separate file.

Thanks,
NeilBrown

--Sig_/BPp32Zu4HPh7ukdbCbRD4lJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwO60Dnsnt1WYoG5AQLQjA//QyGbdLh9gX5GXKIGh8GlTQnmVLjsGbQR
EftSIj+LLhANozHcca2kigSGqm8F1UvC0W0zxW16a7Xun3x0saQn5Cq5eEPSaQhk
83uU565otNhtl+yB2BbZyBj/kCXV7DEyiJ/d3YWJTasu70rEOQISz1C6qHNoFPoG
Yt5AADTUm0/5GAMWdmUZRNw53jyKATb1W2VKEHSo/bwSOFEPpwDahNjTWDsVcM3I
atXy0IGQRjxfP9tFnvUqakFyj0ONx4skN2xEP54KaPtvV8KOlo6ERhCb/wxaetrf
gva4FycTW92ta1qt9PTDoOX6mls5+uLNpWHPUX/tYiRdYc/f55ea4fuCgMbQLJYi
3cZSTzFea/TC+KPet+0GtuPpblA8F6ybY3nNOGI2nU58jYSZkyOI9nwc14ZdCEO1
DfzsCxRQOMFY6PH5gn6FU53A6htxN+J3pMZFjc1uvUP1RJGow3A5xQa313lq4/pI
cdQBiu485lFbwYWwis+tqYxI8w+q4kfJQIxcSVfOdsS2eisZqR5ykRWjNJntB0kj
KXBgC9nPNfTBOLI2oTNJA0eNOKaDdmW2zSnOP0ZNEfbaDcLx9KMSuHgJJGhPVbBJ
ZNi411lobjFwmqpq8CPaMT9/BY7mhY/YURlf54dJzAtuQLSxgXeerxCryYqTiGt3
zycce9Txw58=
=LShv
-----END PGP SIGNATURE-----

--Sig_/BPp32Zu4HPh7ukdbCbRD4lJ--
