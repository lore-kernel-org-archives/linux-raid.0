From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: which is better: promise fasttrak-lite 100 or linux software raid?
Date: Tue, 17 Feb 2004 18:34:08 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040217173408.GM9242@marowsky-bree.de>
References: <LAW11-F70YgChqj8Euz00052987@hotmail.com> <1077035825.25157.5.camel@stoneburner.xwredwing.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1077035825.25157.5.camel@stoneburner.xwredwing.net>
To: Matt Thrailkill <xwred1@modestolan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-02-17T08:37:05,
   Matt Thrailkill <xwred1@modestolan.com> said:

> A Hardware raid controller is always an add-on card, it never comes
> distributed on a motherboard. It has a bios which you can enter befor=
e
> booting into any OS and usually supports 0,1,1+0,and 5 at a minimum. =
It
> has a full CPU onboard that does all raid calculations and I/O, and
> displays itself to the OS as configured by the raid controller (i.e. =
if
> you configure a single raid 5, from 3 drives, it will show up by the =
OS
> as one big drive). A Hardware RAID will always be faster than a softw=
are
> raid, and consumes MUCH less CPU time.

The first part of the last sentence is wrong.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering	      \ ever tried. ever failed. no matt=
er.
SUSE Labs			      | try again. fail again. fail better.
Research & Development, SUSE LINUX AG \ 	-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
