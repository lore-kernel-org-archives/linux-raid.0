From: Khem Raj <raj.khem@gmail.com>
Subject: Re: [PATCH] Define _POSIX_C_SOURCE if undefined
Date: Wed, 13 Jan 2016 20:02:38 -0800
Message-ID: <12D2DAF6-2702-442A-B655-E7D540BC1B7A@gmail.com>
References: <1452671964-35006-1-git-send-email-raj.khem@gmail.com> <87mvs96ljh.fsf@notabene.neil.brown.name>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: multipart/signed; boundary="Apple-Mail=_A21170BB-FB38-4A8A-AB1E-47DF88C03E87"; protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87mvs96ljh.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_A21170BB-FB38-4A8A-AB1E-47DF88C03E87
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi NeilBrown

> On Jan 13, 2016, at 4:40 PM, NeilBrown <nfbrown@novell.com> wrote:
>=20
> On Wed, Jan 13 2016, Khem Raj wrote:
>=20
>> typecast second argument of connect() API to use struct sockaddr*
>>=20
>=20
> Hi,
> You have told us what this patch does, but not why anyone should care.
> Just a sentence or two is probably enough.  Are you getting compiler
> warnings (if so, what are they).  Are we violating some standard =
(which
> one).
>=20

No there is no violation of standard. It helps to port it to work with =
musl
There is code in config.c which
is conditionalized like


#if _XOPEN_SOURCE >=3D 700 || _POSIX_C_SOURCE >=3D 200809L
=E2=80=A6
#endif

but we do not define _POSIX_C_SOURCE, glibc defines it in features.h so
it gets in implicitly with glibc however when we use another libc
implementation e.g. musl this define is not defined in libc and open
group documentation says application should ensure that the feature test
macro _POSIX_C_SOURCE is defined. So this adds a fallback and lets it
port to musl.


> Is there a connection between defining _POSIX_C_SOURCE (as described =
in
> the subject) and the second argument to connect (as mentioned in the
> comment above) and the second argument to bind (as not mentioned until
> the code).

No, they are not connected. This is giving compiler diagnostics about =
type
mismatches when using musl
since definitions of sockaddr_un and sockaddr are different.

musl defines the connect signature as

int connect (int, const struct sockaddr *, socklen_t);

which is inline with open group specs.

It doesnt warn with glibc
because the signature of connect() uses a union of struct types for =
second
argument which is a GNU extention. Here are some part from
/usr/include/sys/socket.h


# define __SOCKADDR_ALLTYPES \
  __SOCKADDR_ONETYPE (sockaddr) \
  __SOCKADDR_ONETYPE (sockaddr_at) \
  __SOCKADDR_ONETYPE (sockaddr_ax25) \
  __SOCKADDR_ONETYPE (sockaddr_dl) \
  __SOCKADDR_ONETYPE (sockaddr_eon) \
  __SOCKADDR_ONETYPE (sockaddr_in) \
  __SOCKADDR_ONETYPE (sockaddr_in6) \
  __SOCKADDR_ONETYPE (sockaddr_inarp) \
  __SOCKADDR_ONETYPE (sockaddr_ipx) \
  __SOCKADDR_ONETYPE (sockaddr_iso) \
  __SOCKADDR_ONETYPE (sockaddr_ns) \
  __SOCKADDR_ONETYPE (sockaddr_un) \
  __SOCKADDR_ONETYPE (sockaddr_x25)

typedef union { __SOCKADDR_ALLTYPES
              } __CONST_SOCKADDR_ARG __attribute__ =
((__transparent_union__));


extern int connect (int __fd, __CONST_SOCKADDR_ARG __addr, socklen_t =
__len);


>=20
> Please explain.
>=20
> Thanks,
> NeilBrown
>=20
>=20
>> Signed-off-by: Khem Raj <raj.khem@gmail.com>
>> ---
>> config.c | 3 +++
>> mdmon.c  | 2 +-
>> msg.c    | 2 +-
>> 3 files changed, 5 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/config.c b/config.c
>> index c58c8fe..b308b6c 100644
>> --- a/config.c
>> +++ b/config.c
>> @@ -63,6 +63,9 @@
>>  * but may not wrap over lines
>>  *
>>  */
>> +#ifndef _POSIX_C_SOURCE
>> +#define _POSIX_C_SOURCE 200809L
>> +#endif
>>=20
>> #ifndef CONFFILE
>> #define CONFFILE "/etc/mdadm.conf"
>> diff --git a/mdmon.c b/mdmon.c
>> index ee12b7c..e4b73d9 100644
>> --- a/mdmon.c
>> +++ b/mdmon.c
>> @@ -235,7 +235,7 @@ static int make_control_sock(char *devname)
>> 	addr.sun_family =3D PF_LOCAL;
>> 	strcpy(addr.sun_path, path);
>> 	umask(077); /* ensure no world write access */
>> -	if (bind(sfd, &addr, sizeof(addr)) < 0) {
>> +	if (bind(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
>> 		close(sfd);
>> 		return -1;
>> 	}
>> diff --git a/msg.c b/msg.c
>> index 754630b..45cd450 100644
>> --- a/msg.c
>> +++ b/msg.c
>> @@ -170,7 +170,7 @@ int connect_monitor(char *devname)
>>=20
>> 	addr.sun_family =3D PF_LOCAL;
>> 	strcpy(addr.sun_path, path);
>> -	if (connect(sfd, &addr, sizeof(addr)) < 0) {
>> +	if (connect(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
>> 		close(sfd);
>> 		return -1;
>> 	}
>> --
>> 2.7.0
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Apple-Mail=_A21170BB-FB38-4A8A-AB1E-47DF88C03E87
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iEYEARECAAYFAlaXHeMACgkQuwUzVZGdMxTpmwCfXXYmdF4RheR9KBAx1mRiKlGA
Z34An18xb1xOd/1afiko9YRUhYwpLSpM
=IeqI
-----END PGP SIGNATURE-----

--Apple-Mail=_A21170BB-FB38-4A8A-AB1E-47DF88C03E87--
