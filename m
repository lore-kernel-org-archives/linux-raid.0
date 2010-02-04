From: Doug Ledford <dledford@redhat.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Thu, 04 Feb 2010 13:45:07 -0500
Message-ID: <4B6B15B3.8030205@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	<1263242294-5353-3-git-send-email-dledford@redhat.com>	<20100119110930.107ca42e@notabene>	<4B55F138.7060008@redhat.com> <20100204174009.6072ec07@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD158877C7580048F58F65896"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100204174009.6072ec07@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, initramfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, martin f krafft <madduck@debian.org>, Michal Marek <mmarek@suse.de>, Hans de Goede <hdegoede@redhat.com>, Bill Nottingham <notting@redhat.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD158877C7580048F58F65896
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/04/2010 01:40 AM, Neil Brown wrote:
>=20
> [cc:ing initramfs because anther part of this thread was already
>  cc:ed there, but this is the one I wanted to reply to.
>  cc:ed to various md/mdadm maintainers too]
>=20
> On Tue, 19 Jan 2010 12:51:52 -0500
> Doug Ledford <dledford@redhat.com> wrote:
>=20
>> On 01/18/2010 05:09 PM, Neil Brown wrote:
>>> On Mon, 11 Jan 2010 15:38:11 -0500
>>> Doug Ledford <dledford@redhat.com> wrote:
>>>
>>>> Signed-off-by: Doug Ledford <dledford@redhat.com>
>>>
>>> I really really don't like this.
>>> I wasn't very keen on allowing the map file to be found in /dev,
>>> but this it just too ugly.
>>
>> I've had to rewrite my response to this a few times :-/
>>
>> So, let's be clear: you are objecting to these non device special file=
s
>> being located under /dev.  Not necessarily *where* they are under /dev=
,
>> just that they are under /dev at all.  That's what I get from your
>> statement above.
>>
>> First with devfs, then later with udev, the old unix tradition of only=

>> device special files under /dev is truly dead.  And it should be.  The=

>> files we are creating are needed prior to / filesystem bring up, and
>> they are needed simply in order to fully populate /dev.  In fact, an
>> argument can be made that a new tradition, that files related to the
>> creation and maintenance of device special files belong under /dev wit=
h
>> the files they relate to, has been created.  And this new tradition
>> makes sense and is elegant on the basis that it requires only one
>> read/write filesystem mount point during device special file populatio=
n.
>>  It also makes sense that this new tradition would supersede the old
>> tradition on the basis that the old tradition was created prior to the=

>> advent of hot plug and the need to have any read/write data just to
>> populate your device special files.  The old tradition didn't have the=

>> flexibility to deal with modern hot plug architectures, the new
>> tradition fixes that, and does so as elegantly as possible.
>>
>> That being the case, the big player in the game, udev, is following th=
e
>> new tradition by creating an entire tree of non device special files
>> under /dev/.udev and using that to store the information it needs.  An=
d
>> here mdadm/mdmon are, the small players in the device bring up game th=
at
>> only have minor bit parts compared to udev, holding up progress and
>> playing the recalcitrant old fart.  Sorry Neil, but the war has alread=
y
>> been decided and this is a dead battle.  Files related to device speci=
al
>> file bring up belong under /dev along with the files we are creating.
>> Your claim that these changes are ugly are misplaced and based upon
>> adherence to a dead tradition that has been replaced by a more sensibl=
e
>> tradition.  Maybe you don't like where they are under /dev, but the fa=
ct
>> that they are under /dev is definitely the right thing to do and is no=
t
>> in the least bit ugly.
>>
>>> I understand there is a problem here, but I don't like this approach =
to a
>>> solution.  I'll give it more though when I get home from LCA2010 and =
see
>>> what I can come up with.
>>
>> Feel free to come up with something different.  But, if your solution
>> involves maintaining an additional read/write mount area in deference =
to
>> a long dead unix tradition, I'm just going to shake my head and patch
>> your solution away to something sane.
>>
>=20
> So I've had a good long think about this.
>=20
> Your arguments about using /dev do have some merit.  However they sound=
 more
> like post-hoc justification then genuine motivation.
> If the train of thought went:
>    I need some files that are related to device management.  Where shal=
l I
>    put them?  I know, I'll put them in /dev.
> then it would be more convincing.  But the logic actually went:
>    I need some files to persist from early boot through to when the sys=
tem
>    has all basic filesystems mounted.  Where shall I put them?  I know,=
 I'll
>    put them in /dev.
> That sounds a lot less convincing.

To be fair, if post-hoc versus initial made any difference what so ever,
then so would the fact that I wouldn't have chosen to have these files
exist at all.  I would have made incremental assembly work without a map
file and I would have made imsm superblock handling be in the kernel.
So, I'm dealing with the consequences of decisions I didn't make and
wouldn't have made.  I don't think it's then fair to put some sort of
'premeditated' versus 'dealing with the situation' bias on my response.

> Given that chain of thought I would be more likely to come to the concl=
usion
> "I know, I'll put them in /lib/init/rw".  Or at least I would on Debian=
 -=20
> I don't know that any non-Debian-derived distros support that directory=
=2E

I have no idea.  Not one of the files in question belongs there any more
than in /dev or anywhere else for that matter though, so I wouldn't come
to that conclusion in your shoes.  But I find it somewhat disheartening
to hear you disparage my choice to put the files in /dev because "I just
wanted someplace to throw them" and then you would suggest /lib/init/rw
when in fact, according to this debian bug:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D%23403863#35

the whole /lib/init/rw things is *exactly* that same thing.  It's a "we
needed someplace to throw some files and didn't want to go through
committee so we found someplace we owned and could do what we want"
thing.  In addition, as the person that reported this bug pointed out,
things like pid files and map files are just as big of a FHS violation
in /lib as they are in /dev.  Neither place is the right place.  Hell,
they even had to make modifications to chkrootkit to accommodate this
new directory and the files in there.  Your choice of one over the other
is purely personal aesthetics, and there are real and legitimate reasons
to prefer *not* to have this directory.  Boot complexity being the main
one.  The fact that at least the mdadm map file is an enumeration of
device special files and mdadm devices and as such really belongs much
more in /dev than in /lib is another.

> The fact that Debian does have this directory and stores in there thing=
s that
> are not related to devices suggests that there is a real need for "pers=
ists
> from early boot" that does not fit in /dev.  So if I put mdadm bits in =
/dev
> just because I can then I am making the /proc mistake of valuing pragma=
tics
> over elegance, and that is not a good long-term direction.
>=20
> Your argument that "udev does it so it must be OK" is also fairly weak.=
  I
> would rather be a "recalcitrant old fart" than "wrong" any day.
> The fact that udev uses "/dev/.udev" is already an admission of failure=
=2E

I disagree.

> Prefixing a file name with '.'  effectively says "I don't know where to=
 put
> this, and I know it doesn't really belong here, but I cannot think of
> anything better so I'm going to do it anyway - shhh don't tell anyone".=


I disagree with that too, all except the shhh don't tell anyone part.
Yes dot files by default keep something from being seen.  But in the
context of /dev/.udev the idea makes sense.  The udev files are directly
related to device bring up, but a big part of the reason udev is in use
today was to unclutter /dev and remove device special files that we used
to create *in case* the device existed and replace them with the device
special files that are there for the devices that actually do exist.
So, since udev is there to declutter /dev, it would not then make sense
to turn around and add back in new clutter, so .udev instead of udev.

> If only the founding fathers had given us a $HOME/rc directory for all =
the
> rc files we would be a lot better off.
>
> But there is still a problem that needs to be solved.
>=20
> mdmon needs to be running before any a certain class of md arrays (thos=
e with
> user-space managed metadata) can be written to.  Because some filesyste=
ms
> choose to write to the device even when the filesystem is mounted read-=
only
> (which should be a hanging offence, but isn't yet)

Just to sidestep a second on the filesystem issue, there are only two
choices when it comes to filesystems: allow them to be mounted read only
(truly read only) and inconsistent or pseudo read only (where the
filesystem itself is the only thing that writes to the filesystem) and
be able to guarantee consistency.  The only way for a journaled
filesystem to provide the guarantee it does is that it writes to the
device during mount even if its a read only mount.  This is because they
guarantee to always be able to *restore* a filesystem to a sane state,
not that it will always *be* in a sane state.  If they didn't do that
restore on mount, then possibly the thing that is inconsistent is
/sbin/init and the machine doesn't boot.  In other words, the point of a
journaled filesystem would be wasted if they didn't do what they do.
The only other option is to do the replay in page cache and allow the
page cache and physical device to differ until the filesystem goes read
write, but I'm not sure that level of complexity is warranted or
advisable, especially since it could easily confuse anything that tries
to read from the disks directly.

> we potentially need mdmon
> running before the root filesystem is mounted.
>=20
> Because we want to unmount and completely discard the filesystem that h=
olds
> the mdmon binary that was run early, we need to kill it and start a new=
 one
> running from final namespace.  This is also needed as to a small extent=
 the
> filesystem is used to communicate between mdadm and a running mdmon, an=
d
> having them have the same root is less confusing.
>=20
> There are three ways we can achieve this.
>=20
> 1/ If we can assume that between the time when the original "mount" com=
pletes
>    and when the "mount -o remount,rw" happens the filesystem doesn't wr=
ite to
>    the device, then we can simply kill mdmon after the root is mounted,=
 and
>    restart it before remounting.   However I don't trust filesystem
>    implementers so I won't recommend that.
>=20
> 2/ Before the pivot root we can kill the old mdmon and start the new on=
e
>    chrooted into the final root.
> 3/ After the pivot root we can kill the old mdmon and start the new one=
=2E
>=20
> Number 2 is the approach that we (Well mostly Dan) originally intended =
and
> that the code implements ... or tries to.  It got broken and I never
> noticed.  I think I have fixed it now for 3.1.2.

Note, as I recall, Hans switched things to be #3 for various reasons.
That he switched it to #3 doesn't effect mdmon really, as it still is
just killing and restarting, but doing it after the pivot root solved a
couple issues.  I don't recall what they were, you would have to talk to
Hans about that.

And you left part of the issue out.  Yes, all the before bring up stuff
is true, but also true is that we want mdmon to hang around longer than
anyone else.  By the time mdmon is ready to be shutdown, /var/run is
once again read only.  So clean up can't be done.  On the other hand, if
the files for mdmon are on a temporary filesystem that is rebuilt at
every boot...you get the point.

> However it requires that /var/run exists and is writeable during early =
boot.
> I'm not sure that I am really comfortable requiring that.  If the conte=
nts
> of /var/run are not going to persist then it would be better if they di=
dn't
> exist.  mdadm current relies on that non-existence for proper handing o=
f the
> "mapfile".

Can you explain this?  I see nothing in the sources that tells me what
you mean by the non-existence of /var/run causing the mapfile to be
handled properly (and I'm not sure that's a valid requirement to put on
the system anyway because now you are dictating that if another early
boot application needs read only access to /var/run and we create
/var/run for that purpose, then it would in some way break mdadm's
operation).

> Number 3 would seem simplest except for the simple task of
> finding out which process to kill, and how to wait for it to clean up a=
nd
> die.=20
>=20
> This is where the suggestion of putting some key files in /dev comes fr=
om.
> If the mdmon pid file and socket were in /dev then a new mdmon would be=
 able
> to find them, signal the pid, and read on the socket until it got EOF
> (because the other end was closed).  If they aren't in /dev (or /lib/in=
it/rw)
> then it isn't possible to find them.
>=20
> I could hunt through /proc to find the process called "mdmon" with the =
right
> args, kill that, and wait until it has gone.  But that is rather ugly a=
nd I
> want to avoid "ugly".
>=20
> A really key consideration here is to make it all really easy for the d=
istro
> package maintainers because debugging issues with early boot is really =
hard,
> and the maintainers have all got more interesting things to do with the=
ir
> time.
> So while I could suggest that the above ugliness be put in a script if =
you
> don't want to make /var/run persist from early boot (my preferred solut=
ion),
> I'm not going to do that.
>=20
> I think that what I will do is:
>=20
>  - the "official" homes for the pid and unix-domain-sock are in /var/ru=
n
>    (preferably /var/run/mdadm/ but Doug said something about needing
>     /var/run/mdmon/ to placate the monster that is SELinux - I need mor=
e
>     information about that).

mdmon does not need access to sendmail, so it should not be in the same
context as the mdadm files.  This allows a more restrictive set of perms
on mdmon than on mdadm itself.  If we put the mdmon files in
/var/run/mdadm, then they will have to have the same context as mdadm,
and because mdadm does so many things, it's already got an overly
liberal set of permissions compared to what mdmon realistically needs.

>    When mdadm wants to communicate with mdmon it always looks there.
>=20
>  - There is an alternative home which is /lib/init/rw/mdadm/ by default=
,

What happens to the files later in the boot process.  Are they left
here?  Or are they migrated to an appropriate location later?  If they
are just left here, then this makes even *less* sense than putting the
files under /dev as you've created a diversion zone in the filesystem.
Someplace to throw things that *should* be elsewhere and then leave them
there.  Hopefully nothing gets left here.  And if nothing gets left
here, then whether the temporary spot is
/dev/gonna_be_deleted_after_stuff_is_moved_out or /lib/init/rw makes no
real difference except in the complexity of the initramfs, and more
complex is more prone to break so I go with the single rw mount point/are=
a.

>    but a 'make' option can easily change that if a distro wants to.

Thank you, I'm sure I'll end up using that.

>    If I cannot access or mkdir /var/run/mdadm, I will mkdir /lib/init/r=
w/mdadm
>    to have some where to create files

And so we are back to preserving two different read/write areas in the
filesystem for very early boot, at least in the default, which is why
I'm sure I'll use the make option.

>  - mdadm when run in the "take over from previous instance" mode will
>    look in /lib/init/rw/mdadm for the relevant .pid and .sock files if =
they
>    aren't in /var/run/mdadm

Now I'm a bit concerned.  What happens when the new program starts up?
If /var/run is now read/write, will the new mdmon then write the files
in /var/run/mdadm (or mdmon)?  If it does do this in preference to
/lib/init/rw/mdadm, which I would expect because if it doesn't then the
issue that Bill Davidson brought up about the issue not being files
under /dev but actually being certain files *not* being under /var/run
creeps right back up.  So, are you going to symlink /var/run/mdadm (or
mdmon) to /lib/init/rw/mdadm?  If so, then you are now doing *exactly*
as I proposed except in /lib/init/rw/mdadm instead of something like
/dev/md/.mdadm.  If you don't, then I foresee problems in your future in
that when mdmon is restarted in the root context, it will write files in
the real /var/run/mdadm directory, but before mdmon ever shuts down, the
/ filesystem will be readonly, and so those files will never get
cleaned, and on the next boot you will have stale files there that you
will have to workaround when it comes mdmon restart time as you'll need
to ignore or clean out /var/run/mdadm and then use the ones in
/lib/init/rw/mdadm instead.  I'm sorry Neil, but this is sounding uglier
and uglier by the minute, not elegant.

>  - mdmon.8 will list the various options with details.
>=20
>=20
> So I get to maintain a Unix tradition which might still have some life =
it
> after all, and Doug gets a very easy way to patch in his own version of=

> sanity.
>=20
> (comments always welcome - I have made the changes described above and =
pushed
> them to git://neil.brown.name/mdadm, but it isn't to late to change it
> completely if that turns out to be best)

I made my proposal in another email.  But, I didn't necessarily argue
for it.  Since you've argued for yours, and since this is going to a
mailing list that I don't think significant parts of the original thread
went to, I'll present mine with the arguments.

Let's look at this on a file by file basis.  First, for mdadm:

mdadm.map - incremental map file, needs to be read/write before / is
read/write if using incremental assembly on root array.  Used to be
stored in /var/run/mdadm/mdadm.map.  This isn't read/write early enough,
so incremental assembly would break.  Neil noted something above about
if /var/run/mdadm doesn't exist and isn't writable then mdadm does
something different in mdadm current, but I looked in the git repo and
could not see where the specific problem a readonly /var/run caused
would be fixed, so I'll assume for now that a readonly /var/run is still
just as broken as before.  We moved the file to /dev/md/.mdadm.map, but
Neil didn't like that and made it /dev/.mdadm.map instead.  I would
actually propose /dev/md/incremental.map as it A) isn't hidden and I
believe it shouldn't be hidden because of E later on, B) clearly
indicates the purpose of the file, C) would be in an md specific/owned
area of /dev, D) is unlike to ever conflict with someone's desired md
device name, E) is a file specific to the enumeration and bring up of md
device special files and as such can be argued to belong in /dev anyway,
and F) solves the problem of needing a read/write /var/run for
incremental assembly to work.

mdadm.pid - this is only used my mdadm in monitor mode, which is not
started until after the filesystem is read/write.  This can safely
reside in /var/run/mdadm as it does today, no changes needed.

Now the files for mdmon:

devname.pid, devname.sock - we use one mdmon per imsm array and each
mdmon has its own pid and sock file named after the array it is
watching.  The problem being that if our root filesystem is on one of
these imsm arrays, we need mdmon up and running so it can mark the array
dirty because we will likely cause writes via possible journal replays
as we mount root.  Likewise, even though there is code in mdmon to clean
up the pid/sock files, if we are talking about the mdmon for the root
filesystem, that cleanup can't happen as we need mdmon around to mark
the array clean after the final writes from going readonly are complete
(and in fact, during the final halt script on Fedora, we specifically
exclude *all* mdmon instances from the last killall that we do, then we
call mdadm to --wait-clean so we know that all the mdmons have marked
the devices clean after the readonly remount, then we reboot, so we
don't even kill the mdmon programs, ever).  That means they will never
clean up their sock and pid files.  As it turns out, being on a tmpfs,
permanently, is best for the mdmon files.  We need them to be written
before the system comes up, and we need them to stick around while the
system goes down (we actually read the pid files to find what pids to
omit from the global killall we do), but we also want them to go away
when we reboot.  So, location wise, /dev isn't necessarily the right
place for them.  However, now that we use udev for dev, semantic wise
it's perfect.  And we do have the one argument that they are at least
related to the bring up and take down of device special files.  So, for
these files, I would actually argue for either /dev/.udev/mdmon with a
symlink from /var/run/mdmon to this location, or for /dev/md/.mdmon,
again with a symlink from /var/run/mdmon.

So that's my suggestion for how to handle this stuff.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigD158877C7580048F58F65896
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktrFbMACgkQg6WylM+/8ZSHTQCdGGPYPOfITXsgZN8/uweUssPH
JJIAoLY+grZ1J5y1dD1V53aOHJr4WDs3
=cPZV
-----END PGP SIGNATURE-----

--------------enigD158877C7580048F58F65896--
