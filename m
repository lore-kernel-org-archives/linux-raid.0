From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 2/3] Don't tell sysfs to launch the container as we are
 doing it ourselves
Date: Fri, 06 Jan 2012 13:35:12 -0500
Message-ID: <4F073EE0.2000802@redhat.com>
References: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com> <1319204000-6661-3-git-send-email-Jes.Sorensen@redhat.com> <20111223104843.6ef30cba@notabene.brown> <4F02D76A.1010002@redhat.com> <4F0324C1.706@redhat.com> <20120104133456.5ac6a260@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD7AE3950DB5255E1F0B39C66"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120104133456.5ac6a260@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD7AE3950DB5255E1F0B39C66
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/03/2012 09:34 PM, NeilBrown wrote:
> On Tue, 03 Jan 2012 10:54:41 -0500 Doug Ledford <dledford@redhat.com> w=
rote:
>=20
>> On 01/03/2012 05:24 AM, Jes Sorensen wrote:
>>> On 12/23/11 00:48, NeilBrown wrote:
>>>> On Fri, 21 Oct 2011 15:33:19 +0200 Jes.Sorensen@redhat.com wrote:
>>>>
>>>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>>
>>>>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>> ---
>>>>>  Incremental.c |    1 -
>>>>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/Incremental.c b/Incremental.c
>>>>> index 1a9a97b..cff7663 100644
>>>>> --- a/Incremental.c
>>>>> +++ b/Incremental.c
>>>>> @@ -446,7 +446,6 @@ int Incremental(char *devname, int verbose, int=
 runstop,
>>>>>  	if (info.array.level =3D=3D LEVEL_CONTAINER) {
>>>>>  		int devnum =3D devnum; /* defined and used iff ->external */
>>>>>  		/* Try to assemble within the container */
>>>>> -		sysfs_uevent(&info, "change");
>>>>>  		if (verbose >=3D 0)
>>>>>  			fprintf(stderr, Name
>>>>>  				": container %s now has %d devices\n",
>>>>
>>>> Hi Jes,
>>>>  I've had to revert this patch as it causes a regression.
>>>>
>>>> Without the 'change' event the container device doesn't get created =
in /dev.
>>>>
>>>> I'm not sure udev should be running "--incremental" on containers an=
yway, but
>>>> if it does it shouldn't cause problems should it?  If it does we sho=
uld fix
>>>> those problems.
>>>
>>> Hi Neil,
>>>
>>> I am wary of this being reverted as it fixed a genuine race condition=
=2E
>>> On Fedora we don't have the problem with the container device not bei=
ng
>>> created, could it be that your udev scripts are not doing the right
>>> thing in this case?
>>
>> I think it's probably worthwhile for us to do a udev rules file
>> comparison.  So, I'm attaching the patch we apply to the udev rules fi=
le
>> in your distribution before installing it, as also the rules file that=

>> handles incremental assembly on Fedora/RHEL.  Look them over and see i=
f
>> you want to include any of the things we have there in your version.
>>
>> As to the question of udev running incremental on containers, I think
>> it's fair to say that either udev or mdadm should be doing so, and not=

>> both.  Whether it should be one or the other is up for debate I think.=

>> Doing it in mdadm where this patch pulls it out means that it only
>> happens on add of a new device using incremental assembly.  The udev
>> version does it on a change event on the container.  The question I ha=
ve
>> is, if you had mdmon migrate a spare into a container, would it trigge=
r
>> this code in mdadm versus would it trigger the code in the udev rules
>> file?  Is there any situation where a change triggered via something
>> other than incremental assembly would result in us needing to run
>> incremental on the container?  If the answer is yes, then I would
>> recommend doing things in the udev file versus in the incremental
>> function of mdadm.
>>
>>
>=20
> Nothing's ever easy.....
>=20
> I just tried to reproduce the problem I had which lead me to revert tha=
t
> patch, but mdadm didn't behave as I expected.

Don't you hate it when that happens ;-)

>  So now I'm running my test
> suite with the revert removed to see what happens.
>=20
> However I think that if triggering a change event at that point (or at
> any point) causes a problem, then the problem was already there and nee=
ds to
> be fixed.  If there is a race as you say (and I suspect you are right) =
then
> we need to put in appropriate locking to make sure the race doesn't cau=
se a
> problem. Just removing the code that triggers the race isn't really eno=
ugh.

Agreed.

> I think that *both* mdadm and udev should be trying to assemble the con=
tents
> of a container when the container changes.  I'm not convinced that ever=
yone
> will be running udev though most probably will.  Again: if this is racy=
 we
> should identify and lock-out the races.

Agreed.  So, I'm going to take this opportunity to make a suggestion.
The md map file has shown to be racy over and over again.  There are
races on incremental assembly, I had to solve races in the udev assembly
from the initramfs or else devices belonging to the same array could end
up in multiple partially assembled arrays, etc.  In the interest of full
disclosure, I always thought the md map file was a solution to a
non-existent problem (a belief that is only getting stronger by the
problem BTW).

Therefore, I suggest we do away with the map file entirely.  It isn't
really necessary and it causes a number of issues (the map file is the
only thing that the mdadm binary uses that has to be available from the
initramfs...mdmon would still need pre-init love, but not mdadm).

What's wrong with the map file?  It's needlessly redundant.  We don't
need to track what arrays we are processing in a file, they are already
tracked in the proper place: the kernel.  We simply need to look at
existing arrays to determine if a new device can be added to an existing
array or if we need to create a new one.

I propose that mdadm be modified so that on incremental assembly we take
a non-exclusive open of /proc/mdstat, compare the uuid of our component
device to the uuid of the already existing arrays, if it matches then
add the device to the existing array, if none matches then transition to
an exclusive open of /proc/mdstat (this is our locking to protect
against multiple creations at the same time), once we get the exclusive
open rescan the file in case a new array was added between our initial
scan and the exclusive open, if there is a new array that matches our
uuid (multiple mdadms racing to create the array) then add our device to
that array, else create a new array with our device as the first device,
drop the exclusive open on /proc/mdstat, do container incremental if
needed, then exit.

Under that method of operation, we never have to worry about name
mapping as we will use the uuid exclusively except when creating the
array, so we only have to figure the name out once and then from that
point on any device with a uuid that matches the created array will just
get added to that array.

We might have to modify monitor mode to not hold /proc/mdstat open all
the time to make this work though.  I would actually prefer some other
file besides /proc/mdstat, but I was hoping to use a file that already
exists and not one that would have to be created on bootup.  Worse case
scenario though, we create a lock file for this specific purpose.

> I don't see how your 'migrate a spare' scenario is relevant but I've pr=
obably
> missed something.

It was just a thought exercise.  The point being: is there any place
other than incremental assembly that might cause a transition from
unrunnable to runnable and therefore should do incremental on the contain=
er.

> The scenarios we have been talking about are for assembling a device on=
ce all
> the required components become available.  A 'spare' cannot possibly be=
 a
> required component so it doesn't seem relevant.
> When a spare is migrated in, mdmon should notice and take whatever acti=
on is
> necessary.  This is quite separate from mdadm or udev.
>=20
> And I've found out the details of the regression.  It is another race :=
-(
>=20
> It particularly affects DDF as DDF containers can have a name.
>=20
> When you "mdadm -I /dev/thing" the first device in a DDF container it w=
ill
> firstly "set_array_info" to set up the array, then add the info to the =
'map'
> file.
>=20
> The set_array_info (or probably the "open" before that) will trigger th=
e
> "ADD" uevent which will run mdadm which should create the /dev/md/WHATE=
VER
> link.
> However if this happens before mdadm updates the 'map' file it won't be=
 able
> to create the link.

Again, map file bad, kernel is authoritative and should be all we need.

> So we need to trigger a 'change' event after updating the map file.
>=20
> There are probably other ways to fix this.  We could maybe update the m=
ap
> file before creating the array device, but that feels clumsy - error ha=
ndling
> would be messy.
>=20
> We could hold the mapfile locked from before creating the device to aft=
er
> updating the map file.   Then make sure the mdadm that is run from udev=
 waits
> for the lock before looking for the name of the array.  That is probabl=
y
> better.

Or make sure the kernel ioctl for setting the name of the array issues a
udev event once the name is set and not before and then create the links
based on the kernel data, no need for the map file.

> In any case I think we need to give some serious thought to locking to =
avoid
> races between different mdadm.  We have some in place already - just ne=
ed to
> make sure it is used consistently.
>=20
>=20
> Some of the changes you have made to the udev.rules file look worth whi=
le.
> Having two separate files is probably a good idea - one for devices whi=
ch are
> array and one for devices which might be members of arrays.
>=20
> The various options for skipping things look a bit painful.
> i.e. we test for
>   ANACONDA

That's obviously Red Hat specific (well, Red Hat and derivatives).

>   DM_MULTIPATH_DEVICE_PATH

This is LVM generic and so applies to any distro.

>   noiswmd
>   nodmraid

These two are dracut specific.  I don't know which distros are or will
pick up dracut, so I don't know how generic this really is.

> The last two are probably OK.

Cool.

>  The first two I would rather see something else
> set a generic "Don't include this device in anything - I've got it
> under control" setting, and then the mdadm rules file just checks that =
and
> ignores as appropriate.

I dunno, the Anaconda item and the LVM item really mean two distinct
things.  In the anaconda case, we aren't ever going to do anything.  The
anaconda environment setting is global and will be present on all
devices we ever look at.  The LVM flag is device specific.  We are going
to see this exact device again, but only after LVM has created the
necessary multipath device and we are scanning the multipath device.
And our actions in these two cases are pretty unique.  For instance,
just because we shouldn't process the multipath device doesn't mean the
SCSI block device rules shouldn't be run.  So it's not like a global
"don't touch this device" flag is really even appropriate, we would need
a global "md raid don't touch this device" flag instead, at which point
you might as well just do it ourselves like we are now.

> It would be good if everything in the rules file in the main distributi=
on
> were equally appropriate for all distros, and that any change a distro =
wanted
> to make could be done in a separate file.

Well, equally applicable to all distros, or at least non-intrusive for
other distros.  For example, it would be possible to include the various
tests in the udev rule file you distribute because even if other distros
don't use noiwsraid or nodmraid or any of the others, lack of the item
does not negatively affect operation of the rules file.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enigD7AE3950DB5255E1F0B39C66
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPBz7gAAoJELgmozMOVy/d15UP/36TsQzYF04Qs9C1ySBRS7d8
rKlTbDMdPBf6ampJmQ6zav/aRtQgijp7nn3cQ/ZZlfW9nFIFh8mByZCULBRiUU/Q
rCpMxgBUKEU3+vfFa4liIO8s4KfCFTI+cuWBR+SNVoA8ZsQw7VzhTkeTiku2DvAC
QwV3NkdeOg8lD0Yh7RQ5xBjRn7mx8kQzozw+H6Wv6bkJPC9yA29QzygzFZ+d1tm6
G2hsJYy2peYowEBZ5+JdCK0Ckycd3nRPNlk+7dnOi47RNqeghUMr/xPe7GmN4jW2
Kb1ZWgkCreHmrRbdxMVbhMEtpwZyNPjm79Ip7/3p/IZSjrh0MGnQWWAFpcZWpRoN
XUvS0WlgtXd91ASZlTmCXh9NtEz8CzxszYmnuGq8bTufDhrvdAafbVDt/LkydrCQ
fFhncz5lo2jY2ViMBb+bEjmvxCpQCf+3zbS5qrjoySTM/Aza9sCq1EwB4UutEbF5
0dX4z/gg+dv6a2fhjNCQuNhp1M503cbFcZDenmgIEVNJgq3TE8MHcCdxk/xMueIk
P/kmelADjrDfW6VUtiMGY3dEZ/d3pXRXADF9azdcwyX2cXm4ZihD1cdQjqblw4cb
V0XsWi+PQGoTK0Gor1yQ50Pb4l5u4kvnImSBGc9G/2Kq8t5faVpPThCZy2EyP3/+
thqxe00zsaNNgkrAhity
=SlwB
-----END PGP SIGNATURE-----

--------------enigD7AE3950DB5255E1F0B39C66--
