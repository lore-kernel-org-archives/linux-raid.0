From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Driver for BIOS-based software RAIDs
Date: Mon, 13 Oct 2003 23:17:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031013211722.GG23916@marowsky-bree.de>
References: <200310131921.45824.thomas@horsten.com> <20031013190323.GD23916@marowsky-bree.de> <200310132025.30939.thomas@horsten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200310132025.30939.thomas@horsten.com>
To: Thomas Horsten <thomas@horsten.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-13T20:25:30,
   Thomas Horsten <thomas@horsten.com> said:

> The problem is that the block device thus assembled won't have suppor=
t for=20
> multiple partitions, for two reasons: the MD driver doesn't align the=
 minor=20
> to any offset, and it doesn't allocate multiple minors for a RAID so =
we can=20
> call register_disk to parse the partition table and create the logica=
l=20
> partition devices. Both of these are defaults, and it might be possib=
le to=20
> tweak.

You probably could change that easily enough.

> Well due to the nature of BIOS RAID's, the user is likely to expect
> that it will be detected and handled automatically without the need
> for a separate setup (since the machine creates the logical device fo=
r
> them, and this works in other OS's that use the BIOS to access the
> drive).

"BIOS RAIDs" is a rather sweet euphemism for "crippled pretense of
hardware RAID, which is in fact emulated by software". I've got no
problem with telling the users that what they have _is_ software RAID
and needs to be treated as such.

Windows doesn't use the BIOS to access the device at all; the
corresponding hardware drivers emulate that.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SUSE LINUX AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
