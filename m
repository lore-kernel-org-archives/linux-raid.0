From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [patch 1/1][mdadm] Fix needed to enable RAID volumes on SAS
	devices (version 2).
Date: Mon, 30 Nov 2009 12:56:44 -0700
Message-ID: <e9c3a7c20911301156k7fc7fac7i33c8de14b0bb4d23@mail.gmail.com>
References: <58C655507FA1494D95397652C4416F35CCF61201@irsmsx503.ger.corp.intel.com>
	 <20091113193545.GW21495@skl-net.de>
	 <1259593942.3178.123.camel@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1259593942.3178.123.camel@awojcik-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Wojcik <artur.wojcik@intel.com>
Cc: Andre Noll <maan@systemlinux.org>, Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hi Artur,

This patch has whitespace damage.    If you use Evolution to insert
the patch make sure you use the "Preformat" formatting option.  A
better alternative is to use the "stg mail" command from Stacked GIT
which, among other things, will format the patch according to akpm's
"perfect patch" guidelines [1].

Some comments below:

> @@ -899,19 +900,12 @@ static int imsm_enumerate_ports(const char
> *hba_path, int port_count, int host_b
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* retrieve the scsi device type */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (asprintf(&device, "/sys/dev/block/%=
d:%d/device/xxxxxxx", major,
> minor) < 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (verbose)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf=
(stderr, Name ": failed to allocate 'device'\n");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D 2;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(device, "/sys/dev/block/%d:%d/d=
evice/type", major, minor);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 str_fmt(device, "/sys/dev/block/%d:%d/d=
evice/type", major, minor);

Admittedly this change isn't needed because asprintf has guaranteed
that the buffer is large enough, but I can see why you made the change
if the goal is eradication of all sprintf calls.

> @@ -1425,6 +1428,36 @@ void append_metadata_update(struct supertype *=
st,
> void *buf, int len)
> =A0}
> =A0#endif /* MDASSEMBLE */
>
> +/* Copyright (C) 2009 Intel Corporation. All rights reserved.
> + *

It is not conventional to claim copyright on a per function basis.

> + * This function formats a string according to format pattern. The
> buffer is
> + * always null terminated even if source string does not fit in
> destination
> + * buffer. The function returns -1 in case of an error and this mean=
s
> + * either one of the input parameters is NULL or there's not enough
> space in
> + * destination buffer to fit even a single character. Otherwise the
> function
> + * returns the number of character put in the destination buffer.
> + */
> +int __str_fmt(char *buf, size_t buf_size, const char *fmt, ...)
> +{
> + =A0 =A0 =A0 va_list vl;
> +
> + =A0 =A0 =A0 if (((int)(--buf_size)) <=3D 0) {

This seems wrong.  Why check buf_size? Just let the normal return
value from vnsprintf indicate if the buffer is too small.  Also it
clips potentially valid sizes that appear negative when casting from
size_t to int.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 errno =3D ENOBUFS;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if ((buf =3D=3D NULL) || (fmt =3D=3D NULL)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 errno =3D EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 va_start(vl, fmt);
> + =A0 =A0 =A0 int result =3D vsnprintf(buf, buf_size, fmt, vl);
> + =A0 =A0 =A0 va_end(vl);
> + =A0 =A0 =A0 if ((result < 0) || (result >=3D buf_size)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 buf[result =3D buf_size] =3D '\0';

Move that assignment to its own line.  In general mdadm tends to
follow kernel coding standards, Neil, of course feel free to clarify.

> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return result;
> +}
> +
> =A0#ifdef __TINYC__
> =A0/* tinyc doesn't optimize this check in ioctl.h out ... */
> =A0unsigned int __invalid_size_argument_for_IOC =3D 0;
> diff --git a/util.h b/util.h
> new file mode 100644
> index 0000000..4be9bc8
> --- /dev/null
> +++ b/util.h
> @@ -0,0 +1,67 @@
> +/*
> + * Linux RAID Management Application
> + * Copyright (c) 2009 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> it
> + * under the terms of the GNU General Public License version 2 as
> published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, b=
ut
> + * WITHOUT ANY WARRANTY; without even the implied warrany of
> MERCHANTABILITY
> + * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
> License
> + * for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> along
> + * with this program; if not, write to the Free Software Foundation,
> Inc.,
> + * 51 Franklin Street, Fifhth Floor, Boston, MA 02110-1301, USA.
> + */
> +
> +#ifndef _UTIL_H_INCLUDED
> +#define _UTIL_H_INCLUDED
> +
> +/* Define PATH_MAX in case we don't use GLIBC or the standard librar=
y
> does
> + =A0 not have PATH_MAX defined. Assume maximum path length is 4K
> characters. */
> +#ifndef PATH_MAX
> +#define PATH_MAX =A0 =A0 =A04096
> +#endif /* PATH_MAX */
> +
> +/**
> + * @brief Wrapper macro for __str_fmt function.
> + *
> + * This macro makes use of __str_fmt() function easier. Use this mac=
ro
> with
> + * caution and only for arrays. Do not use this macro with pointers
> because
> + * the result might be unexpected.
> + *
> + * @param[in] =A0 =A0 __buf =A0 =A0 =A0 =A0 =A0Destination buffer.
> + * @param[in] =A0 =A0 __fmt =A0 =A0 =A0 =A0 =A0Format string.
> + *
> + * @return The return value of this marco is the same as for
> __str_fmt()
> + * =A0 =A0 =A0 =A0 function. See description of __str_fmt() for more=
 details.
> + */
> +#define str_fmt(__buf, __fmt, ...) \
> + =A0 =A0 =A0 __str_fmt((char *)(__buf), sizeof(__buf), (const char *=
)(__fmt), ##
> __VA_ARGS__)
> +
> +/**
> + * @brief Formats a string according to pattern.
> + *
> + * This is printf() like function which formats a text buffer accord=
ing
> to
> + * format pattern. The function stores the result of formating in a
> destination
> + * buffer. The destrination buffer is always null terminated even if
> result
> + * does not fit in it. See description of printf() function for deta=
ils
> on how
> + * to format the output.
> + *
> + * @param[in] =A0 =A0 buf =A0 =A0 =A0 =A0 =A0 =A0Pointer to destinat=
ion buffer where
> the
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 resul=
t of formating will be stored.
> + * @param[in] =A0 =A0 buf_size =A0 =A0 =A0 The capacity of destinati=
on buffer
> including
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 null =
('\0') character.
> + * @param[in] =A0 =A0 fmt =A0 =A0 =A0 =A0 =A0 =A0Pointer to buffer c=
ontainging the
> pattern.
> + *
> + * @return If successful the function returns number of characters p=
ut
> in
> + * =A0 =A0 =A0 =A0 destination buffer, otherwise the function return=
s -1. Check
> errno
> + * =A0 =A0 =A0 =A0 variable to get details about the cause of an err=
or.
> + */
> +extern int __str_fmt(char *buf, size_t buf_size, const char *fmt, ..=
=2E)
> + =A0 =A0 =A0 __attribute__((format(printf, 3, 4)));

I don't like that this function silently does not work with pointers,
and its name belies the fact that it does checking in addition to
formatting.

Perhaps something can be done with gcc builtins for this case.  Have
you looked into __builtin_object_size, __builtin___snprintf_chk and
friends.  The goal being to use these builtins to:

1/ Get a compile time warning when an overflow is detected (currently
supported by the builtins)
2/ Get a compile time warning if the bounds cannot be checked at
compile time (would need some investigation)

--
Dan

[1] http://userweb.kernel.org/~akpm/stuff/tpp.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
