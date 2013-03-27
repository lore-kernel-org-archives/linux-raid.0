From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or destructive
 result?
Date: Wed, 27 Mar 2013 14:11:12 -0500
Message-ID: <51534450.8050905@hardwarefreak.com>
References: <16639206.20.1364400094382.JavaMail.root@zimbra>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16639206.20.1364400094382.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Jeff Johnson <jeff.johnson@aeoncomputing.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/27/2013 11:01 AM, Roy Sigurd Karlsbakk wrote:
> From the manual
>=20
>        -c, --chunk=3D
>               Specify  chunk size of kibibytes.  The default when cre=
ating an array is 512KB.  To ensure compatibility with ear=E2=80=90
>               lier versions, the default when Building and array with=
 no persistent metadata is 64KB.  This is  only  meaningful
>               for RAID0, RAID4, RAID5, RAID6, and RAID10.
>=20
> meaning - chunk size isn't relevant to a mirror

The man page should be changed to explicitly state that --chunk does no=
t
apply to RAID1 or --linear arrays.  Far too many people are having
trouble with this.  For those people the current docs are apparently to=
o
subtle.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
