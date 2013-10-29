From: Levente Kurusa <levex@linux.com>
Subject: Re: [PATCH] mdadm.8.in
Date: Tue, 29 Oct 2013 18:59:39 +0100
Message-ID: <526FF78B.10708@linux.com>
References: <CACcY5Uxc2f6HOxLHt5DY5E71EvFbo0dNmtqUtH=FRwTitE=+zw@mail.gmail.com>
Reply-To: levex@linux.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACcY5Uxc2f6HOxLHt5DY5E71EvFbo0dNmtqUtH=FRwTitE=+zw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Schmidt <johnschmidt4@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

2013-10-29 18:16 keltez=E9ssel, John Schmidt =EDrta:
> I found a small bug in the documentation of mdadm.  I fixed it in my
> local git clone of git://neil.brown.name/mdadm  Here is the change:
>=20
> git diff mdadm.8.in
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 09aff81..006ae59 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -529,7 +529,7 @@ amount of available space is.
>  .BR \-c ", " \-\-chunk=3D
>  Specify chunk size of kibibytes.  The default when creating an
>  array is 512KB.  To ensure compatibility with earlier versions, the
> -default when Building and array with no persistent metadata is 64KB.
> +default when building an array with no persistent metadata is 64KB.
>  This is only meaningful for RAID0, RAID4, RAID5, RAID6, and RAID10.
>=20
>  RAID4, RAID5, RAID6, and RAID10 require the chunk size to be a power
>=20
> Let me know if there are other things I need to do to get this patch =
submitted.

Hi,

I don't think this belongs to LKML.
I am not familiar with linux-raid but I think that the following guidel=
ines
do apply there as well.

https://www.kernel.org/doc/Documentation/SubmittingPatches

Other than this, the patch is a legitimate one, I am sure it will be ac=
cepted.


--
Regards,
Levente Kurusa
