From: Doug Ledford <dledford@redhat.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 	support handoff after pivotroot
Date: Tue, 02 Feb 2010 13:19:44 -0500
Message-ID: <4B686CC0.4030103@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	 <1263242294-5353-3-git-send-email-dledford@redhat.com>	 <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>	 <4B673A5D.2010901@tmr.com> <4B674860.7080604@redhat.com>	 <4B6758C7.9060301@tmr.com> <4877c76c1002012008u2e32d6a4y9b4fec721dfe8435@mail.gmail.com> <4B6847EA.8010509@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig409137D156412C5C6A3280F7"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6847EA.8010509@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Michael Evans <mjevans1983@gmail.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig409137D156412C5C6A3280F7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/02/2010 10:42 AM, Bill Davidsen wrote:
> Michael Evans wrote:
>> On Mon, Feb 1, 2010 at 2:42 PM, Bill Davidsen <davidsen@tmr.com> wrote=
:
>> =20
>>> Doug Ledford wrote:
>>>   =20
>>>> On 02/01/2010 03:32 PM, Bill Davidsen wrote:
>>>>
>>>>     =20
>>>>> Doug Ledford wrote:
>>>>>
>>>>>       =20
>>>>>> On 01/18/2010 05:09 PM, Neil Brown wrote:
>>>>>>
>>>>>>         =20
>>>>>>> I understand there is a problem here, but I don't like this appro=
ach
>>>>>>> to a
>>>>>>> solution.  I'll give it more though when I get home from LCA2010 =
and
>>>>>>> see
>>>>>>> what I can come up with.
>>>>>>>
>>>>>>>            =20
>>>>>> Feel free to come up with something different.  But, if your solut=
ion
>>>>>> involves maintaining an additional read/write mount area in
>>>>>> deference to
>>>>>> a long dead unix tradition, I'm just going to shake my head and pa=
tch
>>>>>> your solution away to something sane.
>>>>>>
>>>>>>
>>>>>>          =20
>>>>> I don't understand you argument here. Not the one where you say you=
're
>>>>> going to ignore Neil and do what you want because you can, I
>>>>> understand
>>>>> that, but the "additional read/write mount area" part, isn't /var/r=
un
>>>>> r/w on all systems now? Could you clarify why this is "additional"
>>>>> here?
>>>>>
>>>>>
>>>>>        =20
>>>> It's not necessarily read/write in the initrd time frame, and puttin=
g
>>>> the mdadm files there means it would have to be.  We didn't make the=
se
>>>> changes because we wanted to, we made them because using mdadm raid
>>>> arrays for the root filesystem combined with incremental assembly or=

>>>> with imsm raid devices was broken otherwise.
>>>>
>>>>
>>>>      =20
>>> Do understand that my disquiet related to this isn't because you put =
a
>>> non-device in /dev, it's that you
>>> didn't put a process PID in /var/run. And frankly, once you let
>>> (force) one
>>> group of threads to be somewhere
>>> else, other services will want their PIDs some other place, and anyon=
e
>>> maintaining an application
>>> which presents information on what's running will need to know where
>>> that
>>> information.
>>>
>>> In other words, it's not where you put it, it's where you *didn't*
>>> put it,
>>> that seems to be an
>>> invitation to put stuff just anywhere. Neil argues that they are not
>>> devices, I argue that
>>> they are PIDs. It's not as though it were a huge effort to move it af=
ter
>>> pivot root, it's a little code
>>> or script and in space which will be released.
>>>
>>> --=20
>>> Bill Davidsen <davidsen@tmr.com>
>>>  "We can't solve today's problems by using the same thinking we
>>>  used in creating them." - Einstein
>>>
>>> --=20
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>    =20
>>
>> Thank you for stating your concern; I think knowing that a very
>> plausible solution is obvious.
>>
>> # at initrd/initramfs creation time
>> ln -s /dev/.run /var/run
>>
>> #initrd/initramfs script
>> mkdir /dev/.run
>>
>> The usual area becomes a symlink to a memory disk .Most systems have
>> ample memory to support a few extra tiny files there. Cleanup on
>> reboot is automatic. Any systems that are memory constrained probably
>> already either have a drive they could swap this data out to, or would=

>> rather save the writes from reaching flash media anyway.
>>
>>  =20
> The only possible side effect of that is that applications which put
> information in /var/run/subdir would have to create the subdir at run
> time rather than at the time of installing the application. And looking=

> at my /var/run directory many applications do seem to have
> subdirectories in /var/run which were created when the applications wer=
e
> installed. I count 31 on this system, a quick check on other systems
> reveals up to 41 and 14-24 of those directories have not been used sinc=
e
> the system was installed. That is, the applications have never been run=
=2E
>=20
> Does it really make sense to force modification of every application
> which installs a subdirectory in /var/run, and incur the overhead in
> each of those applications of checking for the directory and creating i=
t
> if missing, as opposed to a single line in an init script to copy the
> boot time PID files from /dev to /var/run?

No.

> It seems as if a lot of work
> and overhead is being generated for the applications, just to save a
> tiny bit of work for the people implementing a new boot procedure.
>=20
> (cd /dev .run && find . -depth | cpio -pdm /var/run; cd -; rmdir /dev/.=
run)

I'm not sure I would do this either.  While moving the file is possible,
mdmon is actually intended to be run longer than the /var/run filesystem
might be read/write.  I think I would leave the mdmon files in /dev
somewhere and link to them from /var/run.

> Not only would this need a change in Fedora packages, but anyone writin=
g
> a package for Linux in general would have to do it "the Fedora way" and=

> even though Fedora is popular, I think some applications would choose t=
o
> avoid the overhead and need ugly hacks in rc.local to create the
> directories at boot.
>=20
> All in all, I think the overhead belongs in the boot process, not all
> the existing applications.

It doesn't have to exist either place.  We just need a set, accepted way
to handle the problem.  At this point I'm inclined to suggest that we
use /dev/md/.mdadm and /dev/md/.mdmon for the respective files for each
application (such as /dev/md/.mdadm/mdadm.map and /dev/md/.mdmon/*.pid)
and we use static symbolic links in the rpm/deb package to point from
/var/run to those two directories.  The boot process doesn't have to be
changed, utilities don't have to be changed, only the rpm/deb package
needs updated to include the link and both mdmon and mdadm modified to
create their respective directories if they don't exist already and put
their files in those directories.  That's it.  Well, I'd have to get Dan
Walsh to update the SELinux rules for mdadm too since the real directory
location would change.  But still, relatively painless stuff.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig409137D156412C5C6A3280F7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktobMAACgkQg6WylM+/8ZRrggCgoGqHS3clEX/9Z2SSWG/+QhYG
eY8AmwWgPl0WJsPwI50TmqlJy7ZRrvhT
=rcZM
-----END PGP SIGNATURE-----

--------------enig409137D156412C5C6A3280F7--
