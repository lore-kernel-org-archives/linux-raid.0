From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 0/4] add --preboot argument to mdadm/mdmon
Date: Mon, 23 Jan 2012 11:52:44 -0500
Message-ID: <4F1D905C.1050300@redhat.com>
References: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com> <4F1D89B9.9080802@redhat.com> <4F1D8D27.5070207@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8551309ABA6D382250B868A8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1D8D27.5070207@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8551309ABA6D382250B868A8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/23/2012 11:39 AM, Jes Sorensen wrote:
> On 01/23/12 17:24, Doug Ledford wrote:
>> On 01/23/2012 06:18 AM, Jes.Sorensen@redhat.com wrote:
>>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>
>>>> Hi,
>>>>
>>>> Here is v2 of the systemd/dracut fixes for preboot handling in
>>>> mdadm/mdmon. I have changed the argument over from --initrd to
>>>> --preboot as Neil suggested, as well as fixed up the minor code nits=

>>>> and added documentation to the man pages.
>>>>
>>>> It shows up that I didn't need to add a separate enum for the comman=
d
>>>> line arguments in mdmon since mdadm.h gets pulled in so we can reuse=

>>>> those. If we find that to be an issue, we can always create a separa=
te
>>>> one later.
>> I'm not sure I like --preboot.  I understand the difficulty in finding=

>> just the right option name, but to me, preboot sounds like an option y=
ou
>> would use if you are doing pre-processing of something for a later
>> invokation to use.  And that isn't the case here, so the gut level
>> understanding won't match up with the man page/help output understandi=
ng
>> and I try to avoid that as much as possible.  Since the distinct eleme=
nt
>> is that we want to keep running both before and after the normal root
>> filesystem is mounted and we want all files we open to be off of the
>> root filesystem namespace, maybe --offroot (which is odd enough by
>> itself to forestall any gut reactions and prompt a trip to the help/ma=
n
>> pages as opposed to guessing what the option means)?
>>
>=20
> Kay suggested --preroot on irc - would that do the job? I think that is=

> a bit better than --offroot.

I'd say preroot is better than preboot for sure.  I think I still like
offroot more than preroot though.  We *are* running off root (from the
initramfs, and we are modifying our argv[0] to signal to systemd that we
are doing exactly this).  We *are* keeping our files off of root (in
/run/mdadm versus /var/run/mdadm).  And we are intending to live both
before root (preroot) and also after root (postroot).  So, I find
preroot to be better than preboot, but still not as accurate as offroot.
 Offroot fairly accurately captures what we are doing (although it
doesn't speak to the expected life span of the action, nor does it speak
to the fact that we stay off root only if we are invoked from what will
become the non-root fs, so some sort of check to make sure we are
actually in an initrd/initramfs of sorts might be nice, but I'm not sure
how that would play with things like USB live images where you might
actually want to use the option on a non-initrd environment), where as
both preboot and preroot speak as to when it is used, but not what it
does nor the expected life span of the action.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig8551309ABA6D382250B868A8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPHZBcAAoJELgmozMOVy/dgFIP/2VyUjcNyYjSCoWDgAgHljWz
njjdD2wa0urS0LoWppU9BPirvhaqlSh14f4Vj0EML+Bu9lqckWNUY4gJME2ecWuH
e51+WLcUMIHhTPsDoQt3yRrUnBkO4aZf74110qIUxrwi41K4URYx0YsvQqo0X2Yi
1YQHTMXh6BSOQPh4RAM0lQzyX9s5U/Nh0B5uYo2ljNgRW+8+zx5sQEsnDlK4gPBC
/CrC3AWnHr+WwAEv9UEIkiTB+f5VSJqxk1pTFZ6Q8QHkQ6AH0/fq4yKIWF2ci/TK
lBfbNCO2trUfFjQqUUPPN+GZYdTbsA4A734r20p/J/cSOtvhUe5kR9GWHGI17OAH
BNEcmtgja33vCbxN1HAtiet4IjyBF9THCrq+IizjQmPixj+/mVt5NHumPLduLa+5
gtLd9EJzNq1RSEW/XQ9tpL2nCPZskRqN6yu/45io0hBWyBk0iFfhQV/GvF6e/yO/
SU4lcgs74lR/Hu85TdaYRjFxCRCyUkIpgKJDAGhE4W37Wwce7aWCX3JhRIZrunKO
Jq97P57kFqV0/u8HHUJX6sfxeRwflafgrK4LcSSJgrDV7UazlH+YM4VjEYG0AQ3o
zF57CvLTIsoL64TdVKliYxSIS4m3GfIwGbd0e5Msd4tm2Nzd1OhULiCTUxe2nTuF
4s3puCsHiTSydJkqq57+
=qypZ
-----END PGP SIGNATURE-----

--------------enig8551309ABA6D382250B868A8--
