From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Proposed Enhancements to MD
Date: Tue, 13 Jan 2004 11:24:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040113102433.GK8418@marowsky-bree.de>
References: <40036902.8080403@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40036902.8080403@adaptec.com>
To: Scott Long <scott_long@adaptec.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-01-12T20:41:54,
   Scott Long <scott_long@adaptec.com> said:

Hi Scott, this is good to see!

> - partition support for md devices:  MD does not support the concept =
of
>   fdisk partitions; the only way to approximate this right now is by
>   creating multiple arrays on the same media.  Fixing this is require=
d
>   for not only feature-completeness, but to allow our BIOS to recogni=
se
>   the partitions on an array and properly boot them as it would boot =
a
>   normal disk.

I'm not too excited about this, because Device Mapping on top of md is
much more flexible, but I see that users want it, and it should be
pretty easy to add.

> - generic device arrival notification mechanism:  This is needed to
>   support device hot-plug, and allow arrays to be automatically
>   configured regardless of when the md module is loaded or initialize=
d.
>   RedHat EL3 has a scaled down version of this already, but it is
>   specific to MD and only works if MD is statically compiled into the
>   kernel.  A general mechanism will benefit MD as well as any other
>   storage system that wants hot-arrival notices.

Yes. Is anything missing from the 2.6 & hotplug & udev solution which
you require?

> - RAID-0 fixes:  The MD RAID-0 personality is unable to perform I/O
>   that spans a chunk boundary.  Modifications are needed so that it c=
an
>   take a request and break it up into 1 or more per-disk requests.

Agreed.

> - Metadata abstraction:  We intend to support multiple on-disk metada=
ta
>   formats, along with the 'native MD' format.  To do this, specific
>   knowledge of MD on-disk structures must be abstracted out of the co=
re
>   and personalities modules.

This can get difficult, of course, and needs to be implemented in a way
which doesn't slow us down too much.

> - DDF Metadata support: Future products will use the 'DDF' on-disk
>   metadata scheme.  These products will be bootable by the BIOS, but
>   must have DDF support in the OS.  This will plug into the abstracti=
on
>   mentioned above.

OK. How does the DDF metadata differ from the current md data? Is it
merely the layout, or are there functional differences?

In particular, I'm wondering whether partitions using the new activity
logging features of md will still be bootable, or whether the boot
partitions need to be 'md classic'.

> bit due to the radical changes in the disk/block layer in 2.6.  The 2=
=2E4
> version works quite well, while the 2.6 version is fairly fresh.=20

I'd be reluctant doing any of the work for 2.4, but this is of course
upto you.


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
