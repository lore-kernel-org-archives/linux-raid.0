From: NeilBrown <nfbrown@novell.com>
Subject: Re: [PATCH] Define _POSIX_C_SOURCE if undefined
Date: Thu, 14 Jan 2016 16:36:36 +1100
Message-ID: <87bn8o7me3.fsf@notabene.neil.brown.name>
References: <1452671964-35006-1-git-send-email-raj.khem@gmail.com> <87mvs96ljh.fsf@notabene.neil.brown.name> <12D2DAF6-2702-442A-B655-E7D540BC1B7A@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12D2DAF6-2702-442A-B655-E7D540BC1B7A@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 14 2016, Khem Raj wrote:

> Hi NeilBrown
>
>> On Jan 13, 2016, at 4:40 PM, NeilBrown <nfbrown@novell.com> wrote:
>>=20
>> On Wed, Jan 13 2016, Khem Raj wrote:
>>=20
>>> typecast second argument of connect() API to use struct sockaddr*
>>>=20
>>=20
>> Hi,
>> You have told us what this patch does, but not why anyone should care.
>> Just a sentence or two is probably enough.  Are you getting compiler
>> warnings (if so, what are they).  Are we violating some standard (which
>> one).
>>=20
>
> No there is no violation of standard. It helps to port it to work with mu=
sl
> There is code in config.c which
> is conditionalized like
>
>
> #if _XOPEN_SOURCE >=3D 700 || _POSIX_C_SOURCE >=3D 200809L
> =E2=80=A6
> #endif
>
> but we do not define _POSIX_C_SOURCE, glibc defines it in features.h so
> it gets in implicitly with glibc however when we use another libc
> implementation e.g. musl this define is not defined in libc and open
> group documentation says application should ensure that the feature test
> macro _POSIX_C_SOURCE is defined. So this adds a fallback and lets it
> port to musl.

Excellent - thanks.

So the first patch would just have the conditional #define, would have
the same subject as your original patch, and would say something like:

 config.c uses _POSIX_C_SOURCE which is defined in features.h when glibc
 is used, but isn't defined when musl is used.  So provide a reasonable
 default.
=20

>
>
>> Is there a connection between defining _POSIX_C_SOURCE (as described in
>> the subject) and the second argument to connect (as mentioned in the
>> comment above) and the second argument to bind (as not mentioned until
>> the code).
>
> No, they are not connected. This is giving compiler diagnostics about type
> mismatches when using musl
> since definitions of sockaddr_un and sockaddr are different.
>
> musl defines the connect signature as
>
> int connect (int, const struct sockaddr *, socklen_t);
>
> which is inline with open group specs.
>
> It doesnt warn with glibc
> because the signature of connect() uses a union of struct types for second
> argument which is a GNU extention. Here are some part from
> /usr/include/sys/socket.h
>
>
> # define __SOCKADDR_ALLTYPES \
>   __SOCKADDR_ONETYPE (sockaddr) \
>   __SOCKADDR_ONETYPE (sockaddr_at) \
>   __SOCKADDR_ONETYPE (sockaddr_ax25) \
>   __SOCKADDR_ONETYPE (sockaddr_dl) \
>   __SOCKADDR_ONETYPE (sockaddr_eon) \
>   __SOCKADDR_ONETYPE (sockaddr_in) \
>   __SOCKADDR_ONETYPE (sockaddr_in6) \
>   __SOCKADDR_ONETYPE (sockaddr_inarp) \
>   __SOCKADDR_ONETYPE (sockaddr_ipx) \
>   __SOCKADDR_ONETYPE (sockaddr_iso) \
>   __SOCKADDR_ONETYPE (sockaddr_ns) \
>   __SOCKADDR_ONETYPE (sockaddr_un) \
>   __SOCKADDR_ONETYPE (sockaddr_x25)
>
> typedef union { __SOCKADDR_ALLTYPES
>               } __CONST_SOCKADDR_ARG __attribute__ ((__transparent_union_=
_));
>
>
> extern int connect (int __fd, __CONST_SOCKADDR_ARG __addr, socklen_t __le=
n);
>

Ok, so adding the casts should happen in a second patch with a subject
like

   Subject: add casts for the addr arg of connect and bind

and then the comment above the patch would say something like:

  glibc allows the addr arg to connect and socket to be any of a number
  of 'sockaddr_*' types, but musl requires 'const struct sockaddr *'
  which is in line with open group specs.  So add casts to allow
  compilation with musl.

If you could resend as two separate patches with appropriate
descriptions (use the above or alter to suit your preference) then it
will be obvious what the purpose of the patches is, and I'll apply them.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWlzPkAAoJEDnsnt1WYoG5tt8P/246qHzI04dk0UpDrYfOMwXX
ocNGt5lIg4VvR61Q8NGMt49SiHnTOtGdjIe/37P8+yJEk5DqExMmgIlwocexBt1P
m8j/PfVv9Jip00gjg/FVR6OovVSGDpESY+iIbvXq9KMFsRljGUGvqpkvu/VBbzw4
wfXMDMvvNtSAbl1hB3+f54xNLyEjZBeTdiOAJo2uDv74JXqzLeMlEJgTrIWOyb+1
2HulIQXcHGfLjVe8+EohsAzcg0u+sBc7QlOpU9nUqpSIalbR+kOMWGxc5SzqJHH4
+EVvCWyc7+AoYOg9tPz1d/HJGyO7ZnerIG1iEAPGTLQaasI8Dak9yAafl1zQrLCg
hBn9KXOzb8/d4tdeHcnYybtuyyBhhYI/WalWsyPjdDD7F17TnMG4lajxa8XJ/fgY
w0Uble0Cc6/QLR3tQwE0p6qbmKyyugd/bD3eBubyw1eOEUNlMXi964yNQBhLzPWy
jErYHt2YR+jkod8ZIQhzjxZQjUYsSw9YkEECsFLogUL5EiLPjacfh0sgLzELWoLh
U/Oqw/p0ZcPJIXRa+wkwRUNhlJ5Cy+cCMjXufKJ5oVHv4pAdgqXQMOFVXe18N9+m
eKwVjNbmraQsm3pFdJvu6L/3Q2nbZx8atTm3lQpkV1Va7nsH8lfRqf7bjKUp6D/v
vSWxZFvnuDg4zPwCDThk
=mf8S
-----END PGP SIGNATURE-----
--=-=-=--
