From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 2/3] Don't tell sysfs to launch the container as we are
 doing it ourselves
Date: Tue, 03 Jan 2012 10:54:41 -0500
Message-ID: <4F0324C1.706@redhat.com>
References: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>	<1319204000-6661-3-git-send-email-Jes.Sorensen@redhat.com> <20111223104843.6ef30cba@notabene.brown> <4F02D76A.1010002@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD0C78391A889216747EDB62E"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F02D76A.1010002@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD0C78391A889216747EDB62E
Content-Type: multipart/mixed;
 boundary="------------090703070705070609040107"

This is a multi-part message in MIME format.
--------------090703070705070609040107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/03/2012 05:24 AM, Jes Sorensen wrote:
> On 12/23/11 00:48, NeilBrown wrote:
>> On Fri, 21 Oct 2011 15:33:19 +0200 Jes.Sorensen@redhat.com wrote:
>>
>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>
>>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>>> ---
>>>  Incremental.c |    1 -
>>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/Incremental.c b/Incremental.c
>>> index 1a9a97b..cff7663 100644
>>> --- a/Incremental.c
>>> +++ b/Incremental.c
>>> @@ -446,7 +446,6 @@ int Incremental(char *devname, int verbose, int r=
unstop,
>>>  	if (info.array.level =3D=3D LEVEL_CONTAINER) {
>>>  		int devnum =3D devnum; /* defined and used iff ->external */
>>>  		/* Try to assemble within the container */
>>> -		sysfs_uevent(&info, "change");
>>>  		if (verbose >=3D 0)
>>>  			fprintf(stderr, Name
>>>  				": container %s now has %d devices\n",
>>
>> Hi Jes,
>>  I've had to revert this patch as it causes a regression.
>>
>> Without the 'change' event the container device doesn't get created in=
 /dev.
>>
>> I'm not sure udev should be running "--incremental" on containers anyw=
ay, but
>> if it does it shouldn't cause problems should it?  If it does we shoul=
d fix
>> those problems.
>=20
> Hi Neil,
>=20
> I am wary of this being reverted as it fixed a genuine race condition.
> On Fedora we don't have the problem with the container device not being=

> created, could it be that your udev scripts are not doing the right
> thing in this case?

I think it's probably worthwhile for us to do a udev rules file
comparison.  So, I'm attaching the patch we apply to the udev rules file
in your distribution before installing it, as also the rules file that
handles incremental assembly on Fedora/RHEL.  Look them over and see if
you want to include any of the things we have there in your version.

As to the question of udev running incremental on containers, I think
it's fair to say that either udev or mdadm should be doing so, and not
both.  Whether it should be one or the other is up for debate I think.
Doing it in mdadm where this patch pulls it out means that it only
happens on add of a new device using incremental assembly.  The udev
version does it on a change event on the container.  The question I have
is, if you had mdmon migrate a spare into a container, would it trigger
this code in mdadm versus would it trigger the code in the udev rules
file?  Is there any situation where a change triggered via something
other than incremental assembly would result in us needing to run
incremental on the container?  If the answer is yes, then I would
recommend doing things in the udev file versus in the incremental
function of mdadm.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford


--------------090703070705070609040107
Content-Type: text/plain;
 name="mdadm.rules"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm.rules"

# This file causes block devices with Linux RAID (mdadm) signatures to
# automatically cause mdadm to be run.
# See udev(8) for syntax

# Don't process any events if anaconda is running as anaconda brings up
# raid devices manually
ENV{ANACONDA}=3D=3D"?*", GOTO=3D"md_end"

# Also don't process disks that are slated to be a multipath device
ENV{DM_MULTIPATH_DEVICE_PATH}=3D=3D"?*", GOTO=3D"md_end"

# We process add events on block devices (since they are ready as soon as=

# they are added to the system), but we must process change events as wel=
l
# on any dm devices (like LUKS partitions or LVM logical volumes) and on
# md devices because both of these first get added, then get brought live=

# and trigger a change event.  The reason we don't process change events
# on bare hard disks is because if you stop all arrays on a disk, then
# run fdisk on the disk to change the partitions, when fdisk exits it
# triggers a change event, and we want to wait until all the fdisks on
# all member disks are done before we do anything.  Unfortunately, we hav=
e
# no way of knowing that, so we just have to let those arrays be brought
# up manually after fdisk has been run on all of the disks.

# First, process all add events (md and dm devices will not really do
# anything here, just regular disks, and this also won't get any imsm
# array members either)
SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add", ENV{ID_FS_TYPE}=3D=3D"linux_ra=
id_member", \
	RUN+=3D"/sbin/mdadm -I $env{DEVNAME}"
SUBSYSTEM=3D=3D"block", ACTION=3D=3D"remove", ENV{ID_FS_TYPE}=3D=3D"linux=
_raid_member", \
	RUN+=3D"/sbin/mdadm -If $name --path $env{ID_PATH}"

# Next, check to make sure the BIOS raid stuff wasn't turned off via cmdl=
ine
IMPORT{cmdline}=3D"noiswmd"
IMPORT{cmdline}=3D"nodmraid"
ENV{noiswmd}=3D=3D"?*", GOTO=3D"md_imsm_inc_end"
ENV{nodmraid}=3D=3D"?*", GOTO=3D"md_imsm_inc_end"
SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add", ENV{ID_FS_TYPE}=3D=3D"isw_raid=
_member", \
	RUN+=3D"/sbin/mdadm -I $env{DEVNAME}"
SUBSYSTEM=3D=3D"block", ACTION=3D=3D"remove", ENV{ID_FS_TYPE}=3D=3D"isw_r=
aid_member", \
	RUN+=3D"/sbin/mdadm -If $name --path $env{ID_PATH}"
LABEL=3D"md_imsm_inc_end"

# Next make sure that this isn't a dm device we should skip for some reas=
on
ENV{DM_UDEV_RULES_VSN}!=3D"?*", GOTO=3D"dm_change_end"
ENV{DM_UDEV_DISABLE_DISK_RULES_FLAG}=3D=3D"1", GOTO=3D"dm_change_end"
ENV{DM_SUSPENDED}=3D=3D"1", GOTO=3D"dm_change_end"
KERNEL=3D=3D"dm-*", SUBSYSTEM=3D=3D"block", ENV{ID_FS_TYPE}=3D=3D"linux_r=
aid_member", \
	ACTION=3D=3D"change", RUN+=3D"/sbin/mdadm -I $env{DEVNAME}"
LABEL=3D"dm_change_end"

# Finally catch any nested md raid arrays.  If we brought up an md raid
# array that's part of another md raid array, it won't be ready to be use=
d
# until the change event that occurs when it becomes live
KERNEL=3D=3D"md*", SUBSYSTEM=3D=3D"block", ENV{ID_FS_TYPE}=3D=3D"linux_ra=
id_member", \
	ACTION=3D=3D"change", RUN+=3D"/sbin/mdadm -I $env{DEVNAME}"

# In case the initramfs only started some of the arrays in our container,=

# run incremental assembly on the container itself.  Note: we ran mdadm
# on the container in 64-md-raid.rules, and that's how the MD_LEVEL
# environment variable is already set.  If that disappears from the other=

# file, we will need to add this line into the middle of the next rule:
#	IMPORT{program}=3D"/sbin/mdadm -D --export $tempnode", \

SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add|change", KERNEL=3D=3D"md*", \
	ENV{MD_LEVEL}=3D=3D"container", RUN+=3D"/sbin/mdadm -I $env{DEVNAME}"


LABEL=3D"md_end"

--------------090703070705070609040107
Content-Type: text/plain;
 name="mdadm-3.1.3-udev.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm-3.1.3-udev.patch"

--- mdadm-3.2.1/udev-md-raid.rules.udev	2011-03-27 22:31:20.000000000 -04=
00
+++ mdadm-3.2.1/udev-md-raid.rules	2011-03-28 10:14:26.047232843 -0400
@@ -2,11 +2,13 @@
=20
 SUBSYSTEM!=3D"block", GOTO=3D"md_end"
=20
+# In Fedora we handle the raid components in 65-md-incremental.rules so =
that
+# we can do things like honor anaconda command line options and such
 # handle potential components of arrays
-ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"remove", RUN+=3D"=
/sbin/mdadm -If $name --path $env{ID_PATH}"
-ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"add", RUN+=3D"/sb=
in/mdadm --incremental $env{DEVNAME}"
-ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ACTION=3D=3D"remove", RUN+=3D"/s=
bin/mdadm -If $name --path $env{ID_PATH}"
-ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ACTION=3D=3D"add", RUN+=3D"/sbin=
/mdadm --incremental $env{DEVNAME}"
+#ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"remove", RUN+=3D=
"/sbin/mdadm -If $name --path $env{ID_PATH}"
+#ENV{ID_FS_TYPE}=3D=3D"linux_raid_member", ACTION=3D=3D"add", RUN+=3D"/s=
bin/mdadm --incremental $env{DEVNAME}"
+#ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ACTION=3D=3D"remove", RUN+=3D"/=
sbin/mdadm -If $name --path $env{ID_PATH}"
+#ENV{ID_FS_TYPE}=3D=3D"isw_raid_member", ACTION=3D=3D"add", RUN+=3D"/sbi=
n/mdadm --incremental $env{DEVNAME}"
=20
 # handle md arrays
 ACTION!=3D"add|change", GOTO=3D"md_end"

--------------090703070705070609040107--

--------------enigD0C78391A889216747EDB62E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPAyTBAAoJELgmozMOVy/dCzoP/AltW7H4ACw1ocCVKQEvLmEv
J5btVUOA6H45yZGjeBzabBxLMeG2zGsS0up5l1Is+U4IHcioevq2nx24Y/jxW5t8
glgUXD+5afQF3fyQldHDtJZLTUhKQaTx4vOc7r+lLzCflfmsZqb+BVMwqJuPaQL9
JyiWp3SmZR8rSSwOkw30ceEeysj5LBJ/gqqykMP6XmVWT+JKDe+4rkn/AZEEzJlz
KgdcbeVHFOzZZE7NN04NnC00WbeaV00rvoguCMAH3HdXJIgYHLsCuLJDcuknlJSP
RJHzmc+QxrgKXGKYe6Z3M1JS8AgFoEcu9FMJYuv9xMjmbt81gLm9lbT5YqooaAA1
AViOmLXfx1SlE9tB0JcMGyE6+YbFz0jWBz4ARs7aLMBHcz3wptOCVtf7PaC43NeP
ufLpM6rfY4rUqAFMpE2B4kAtqqJTGEou1AQtwhfB6Kd5Ybt+6LxyvnA83ic2AHYO
5NXhG/1Hvfy4EpMbqhIGIW+Pf84dN9dS7YWJRoxQDp7gI1Ny5zJuAY+eVf31Iq32
03VGvdd2Rq3FM04k99WTMPCyA84qIafuj0b05HhBgW616G6hqZ3AWP8ntUzhwjGD
HYKb1Ys5HeYyApYUL4EG1OrKbm1HLFy895MxJMHJedkEGle83pKv7YdG+WH9xwQ6
BM5TJijNgm9OaQv53jWR
=clqs
-----END PGP SIGNATURE-----

--------------enigD0C78391A889216747EDB62E--
