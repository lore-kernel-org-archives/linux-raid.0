From: Andrew Morton <akpm@osdl.org>
Subject: Re: raid0_make_request bug: can't convert block across chunks or
 bigger than
Date: Wed, 7 Jan 2004 02:33:32 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040107023332.5ff0b9ff.akpm@osdl.org>
References: <yw1xznd0ult1.fsf@ford.guide>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yw1xznd0ult1.fsf@ford.guide>
To: =?ISO-8859-1?B?TeVucyBSdWxsZ+VyZA==?= <mru@kth.se>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mru@kth.se (M=E5ns Rullg=E5rd) wrote:
>
> I'm using Linux 2.6.0 on an Alpha SX164 machine.  Using four ATA
>  disks, hd[egik], on a Highpoint hpt374 controller, I created two rai=
d0
>  arrays from hd[eg]1 and hd[ik]1, md0 and md1.  From these, I created=
 a
>  raid1 mirror, md4, on which I created an XFS filesystem.  For variou=
s
>  reasons, I first ran md4 with only md0 as a member and filled it wit=
h
>  some files, all going well.  Then, I added md1, and it was synced
>  properly.  Now, I can mount md4 without problems.  However, when I
>  read things, I get this in the kernel log:
>=20
>  raid0_make_request bug: can't convert block across chunks or bigger =
than 32k 439200 32

This was fixed post-2.6.0.  2.6.1-rc2 should be OK.

>  raid1: Disk failure on md1, disabling device.=20
>  	Operation continuing on 1 devices

I assume this is due to the raid0 error above.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
