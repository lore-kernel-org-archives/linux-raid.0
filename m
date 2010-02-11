From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 	support handoff after pivotroot
Date: Wed, 10 Feb 2010 21:30:48 -0500
Message-ID: <4B736BD8.7060902@redhat.com>
References: <1263242294-5353-3-git-send-email-dledford@redhat.com>	 <4B6DAC06.6060909@redhat.com>	 <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>	 <4B702EA5.3030103@redhat.com> <20100209083838.6568cac0@notabene.brown>	 <20100209021949.GB11780@lapse.rw.madduck.net>	 <4B71C6CA.3010407@redhat.com>	 <alpine.LNX.2.01.1002091553580.10004@filesrv1.baby-dragons.com>	 <20100210123321.324e5de6@notabene.brown>	 <e9c3a7c21002100749u2c6d7c51qa0cc1830452f84cb@mail.gmail.com> <4877c76c1002100806w66e504deg767f6ecc8cc7fa8a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8C140BCE2AFA386F6FA74351"
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4877c76c1002100806w66e504deg767f6ecc8cc7fa8a-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Evans <mjevans1983-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, "Mr. James W. Laferriere" <babydr-hujCQpUib4khwW3g317DAQ@public.gmane.org>, linux-raid maillist <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8C140BCE2AFA386F6FA74351
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/10/2010 11:06 AM, Michael Evans wrote:
> On Wed, Feb 10, 2010 at 7:49 AM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org=
> wrote:
>> On Tue, Feb 9, 2010 at 6:33 PM, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
>>> On Tue, 9 Feb 2010 15:58:52 -0900 (AKST)
>>> "Mr. James W. Laferriere" <babydr-hujCQpUib4khwW3g317DAQ@public.gmane.org> wrote:
>>>>
>>>>       But that said ,  the idea of a /'name' area for this is imo a =
very good
>>>> thing .  Rather hiding it below others .
>>>
>>> Thanks.
>>>
>>> One idea that has occurred to me is that maybe /sys is the right plac=
e to put
>>> this stuff!!!  If only sysfs directories could be writeable, I could =
write the
>>> pid file in /sys/class/block/md0/md/mdmon.pid and create a socket wit=
h a
>>> similar name.
>>
>> Hmm... we already have /sys/kernel/debug as a simple mount point for
>> debugfs.  What about adding /sys/kernel/init as a mount point for this=

>> tmpfs?
>>
>> --
>> Dan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
> Except that isn't quite accurate is it?  This is less to do with init
> for the kernel and more to do with various pieces of system state
> information.
>=20
> /sys/early_rw
>=20
> Isn't very descriptive, but might make sense.  It also might not quite
> be what we want to mean, as the files in it could also linger past
> root unmount as the system is brought down.

Well, *no* name really fits well so far.  The fact of the matter is that
we are talking about lots of different types of files, and different
lifetimes for those files.  Eg: dhcp lease file, only needs to be there
until moved after root mounted; mdmon.sock file, can't be moved, but
when mdmon is restart will get new file in proper location (unless we
use this location on restart too in order to avoid shutdown issues,
although I'm not convinced we need to do this, seems to me we could just
as easily switch to using remount ro as the norm instead of umount and
problem solved); mdmon.pid file so we know what processes to restart;
other files too that I'm not so familiar with.  The only thing all these
files have in common is that they violate a core tenet of unix
philosophy/prior art.  Specifically, the concept of everything as a file
in unix means that the unix kernel is not really functional without a
filesystem.  Hence why unix never booted into a basic interpreter
without a disk, but instead always panicked.  But, in the past, old time
unix kernels always brought up the root filesystem before doing anything
else.  That is no longer true, and we are struggling to access our root
filesystem to create files when the real root filesystem does not yet
exist.  That is the one thing all of these files have in common.  That
they are being created before the kernel is ready to deal with files
properly.  So since this is specifically a kernel not ready thing, I
think /sys/kernel makes sense.  Then I would suggest naming whatever we
put in there according to this one common trait.  I could see
/sys/kernel/pre-init-tmp (or ptmp for short).  If someone wanted to do
some neat kernel programming maybe we could make /sys/kernel/early-root
and allow programs to create files in there as well as directory
hiearchies, and maybe add a syscall that would actually move all the
files in here to the real root sometime after pivot root and read write
bring up are complete (that would just be cool...no manually moving
files, just bring root up r/w, clean out /var/run and any other cleanups
we do before proceeding, then do this syscall and get things moved from
early-root to the real root).  Anyway, my $.02.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig8C140BCE2AFA386F6FA74351
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktza9gACgkQg6WylM+/8ZTKPACgrZq6xiHdgtdNEOrEIDPH1dM+
tqsAoJKyYhpHwpgFoXTlpLnZ+kmZ6Tef
=rUVg
-----END PGP SIGNATURE-----

--------------enig8C140BCE2AFA386F6FA74351--
