From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Tue, 06 Apr 2010 22:02:58 -0400
Message-ID: <4BBBE7D2.6090608@redhat.com>
References: <4BBA1289.4010705@redhat.com> <20100407113035.3ca437f2@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEB8F8B014213B50DA328B49C"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100407113035.3ca437f2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEB8F8B014213B50DA328B49C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/06/2010 09:30 PM, Neil Brown wrote:
> On Mon, 05 Apr 2010 12:40:41 -0400
> Doug Ledford <dledford@redhat.com> wrote:
>=20
>> We have incremental mode for supporting hot plug of devices.  However,=

>> we don't support hot-unplug.  This is something we need in order to
>> enable automatic device replacement.  When implementing the support
>> though, I found that we had a problem in that the device special file =
is
>> already gone (well, not gone, but both open and lstat fail on the devi=
ce
>> special file, which really makes Manage_subdevs unhappy) by the time
>> udev calls us to remove the device (even if I created a new udev rules=

>> file with a very low number this was still true).  So, along with addi=
ng
>> the code shamelessly stolen from Hawrylewicz with modifications to mak=
e
>> it work on non-container based arrays, I had to modify Manage_subdevs =
to
>> work on sysfs subdevice entries in the fail and remove cases.  Anyway,=

>> with this in place, and with the modified udev rules file in place,
>> hot-unplug now works (or at least it does in my testing, I didn't try =
a
>> container device, I'll leave tweaking that to Dan or someone else from=

>> Intel, although it should more or less work, I don't know the Intel
>> metadata rules and so didn't try to make it work myself).  And by
>> changing Manage_subdevs to use either a valid device special file or
>> sysfs entries, it will work on the command line with virtually any
>> kernel, and work from a udev rules file on kernels recent enough to ha=
ve
>> the state entry in sysfs subdevs directories.
>>
>> Oh, and Neil should review my man page additions to see if they are
>> sufficient for his tastes.  I didn't get real wordy about the support,=

>> it's pretty straight forward.
>>
>=20
> Thanks...
>=20
> Observations:
>=20
> -In udev-md-raid.rules you add=20
>        OPTIONS+=3D"watch"
>  Why?

udev upstream added it to their version of the file so I brought it over
(hmm, I should say upstream to me, the Fedora
/lib/udev/rules.d/64-md-raid.rules file is packaged as part of udev, and
they added it there, although I can't say for certain that upstream,
upstream also added it, so I was making the files consistent).  I don't
always keep up with the various options in udev, so my assumption was
that if the people who really know it added it, they probably had a
reason and I was just trying to make sure it didn't get lost.

> - I cannot say I like the process of hunting through /proc/mdstat for
>   a device name that textually matches the name that udev has just
>   removed from /dev.  It feels too indirect.
>   I was really hoping to just use /sys/$DEVPATH/holders to find the
>   containing arrays, but $DEVPATH has been destroyed before udev
>   gets to run anything .. even though the final object is still in
>   use.  That is really sad!

I agree.  The fact that everything disappears before we can use it to
remove it from the array was a bit problematic.  And I too thought that
this was too indirect and error prone.  But, the fact remains that A) if
we have that textual name somewhere in some array, then that means that
array holds a reference to that textual name and B) as long as we hold a
textual reference to that name, the name is not free and can not be
reused.  In other words, our removal act is necessarily a barrier
against races.  There can be no two devices with the same textual name,
and if the same device is added back to the system before we have
removed our holder on it, then it gets a totally new name.  So, in
truth, even though it *feels* too indirect, it is in fact perfectly safe.=


>   So we need to either use the block device name (e.g. sdb) as you
>   did or the major:minor numbers. The most direct way to get these
>   is with $name or $major:$minor.  And there is no direct way to map be=
tween
>   them any more, so if mdadm needs both, we have to pass both.
>=20
>   The name can be used for searching /proc/mdstat or
>     /sys/class/block/md*/md/dev-*
>   and can be used for failing/removing via sysfs.
>   the major:minor can be use for searching with GET_DISK_INFO
>   and for failing/removing via ioctl.
>=20
>   So I'm probably going to have to be satisfied with hunting
>   through /proc/mdstat even though I don't like it.
>   But if we can just pass $name to mdadm instead of passing
>   $ENV{DEVNAME} and stripping the "/dev/" it would be a little
>   bit happier. i.e.
>=20
>     mdadm -If sdb
>=20
>   would it help do you think to support e.g.
>=20
>     mdadm -If --devnum $major:$minor $name

As I recall, on a remove event the major minor is already gone too (but
I could be wrong, the machine has since been blown away and reinstalled
and the file I had the whole env during a remove event stored off in is
gone with it).

And I would be careful about using $env{DEVNAME}, in fact I'm removing
usage of it in my local rules files right now because I've found it is
inconsistent (part of the time it includes /dev/ and part of the time it
doesn't, where as $tempnode is consistent).

>   so that mdadm would have the major/minor in case of an old
>   kernel without support for removing via sysfs?
>   Or something horrible like
>        mdadm -If $name($major:$minor)
>   ?? maybe not.

Personally, I'm fine with just the name for the reason I listed above.

> - I'm not a big fan of in/out parameters, particularly when they mean
>   different things (component device / array device).  I would rather
>   replace mdstat_check_active with e.g. mstat_by_component which
>   returns a 'struct mdstat_ent' having search for one with a component
>   matching the arguement.

Fair enough.  I stole that code anyway and it's clunky in that it
expects a /dev/$name input and gives a plain $name output causing me to
have to prefill the char string with /dev/ and then copy /dev/$name
after that and point the function at a ways into the char string in
order to get /dev/$name as output.  Clunky, but it worked.

> - SKIP_GONE_DEVS / KEEP_GONE_DEVS is starting to look really ugly.
>   I wonder if we can get rid of both and always do what KEEP_GONE_DEVS
>   does.  That will probably require changes elsewhere, but I think it w=
ould
>   be a good thing.

I think that would be a good thing.  Even if a device is failed and no
longer has a valid block link, if it's still being held by our array it
should be in the list.  We should simply check that each device is live
when walking the list.

> - man page update looks OK though
>=20
> +has a chance to include it in some array as appropriate.  Optionally,
> +with the
> +.I \-\-fail
> +flag is passed in then we will remove the device from any active array=

> +instead of adding it.
>=20
>   needs to lose 'is' or s/the/if/ or maybe be rewritten.

Oops, s/with/when/ makes it all better.

> Thanks.  I'll try to find time to incorporate some of this - I'd like t=
o
> break it up into 2 or 3 patches.  One to add dev-name searching in mdst=
at,
> maybe one to change how Manage parses device names so "sdb" can be unde=
rstood
> as a different thing to "/dev/whatever", and one to tie it all together=

> and provide the new functionality.
> Oh, and maybe one to get ride of SKIP_GONE_DEVS.

Let me know if you want me to redo/resend any of it.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigEB8F8B014213B50DA328B49C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku759IACgkQg6WylM+/8ZQJKwCfVoPlHHiEJSvlQFW0JlUdBWQn
ulYAn0cGPJRrsSJ1X+jbvUB2pcKJJwnb
=Q0wV
-----END PGP SIGNATURE-----

--------------enigEB8F8B014213B50DA328B49C--
