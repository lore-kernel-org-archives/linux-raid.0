From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Proposed Enhancements to MD
Date: Fri, 16 Jan 2004 10:29:29 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040116092929.GG22417@marowsky-bree.de>
References: <20040113102433.GK8418@marowsky-bree.de> <400432FC.6050209@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <400432FC.6050209@adaptec.com>
To: Scott Long <scott_long@adaptec.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-01-13T11:03:40,
   Scott Long <scott_long@adaptec.com> said:

> The biggest issue here is that a real fdisk table needs to exist on t=
he
> array in order for our BIOS to recognise it as a boot device.

Hm, ok.

> >Yes. Is anything missing from the 2.6 & hotplug & udev solution whic=
h
> >you require?
>=20
> I'll admit that I'm not as familiar with 2.6 as I should be.  Does a
> disk arrival mechanism already exist?

Yes. hotplug already will get you events when new disks arrive.

> >In particular, I'm wondering whether partitions using the new activi=
ty
> >logging features of md will still be bootable, or whether the boot
> >partitions need to be 'md classic'.
>=20
> Our products will only recognise and boot off of DDF arrays.  They ha=
ve
> no concept of classic MD metadata.

OK. The question was meant differently. In 2.6, we have the ability to
log resyncs and journal updates (see the discussions on linux-raid). I
was just wondering whether DDF would allow this, or whether it is a
simple minded "this disk good, that disk bad", and thus the boot drive
might not be able to use the new md features with the DDF metadata.

> This work was originally started on 2.4.  With the closing of 2.4 and
> release of 2.6, we are porting are work forward.  It would be nice to
> integrate the changes into 2.4 also, but we recognise the need for 2.=
4
> to remain as stable as possible.

2.4 is dead and shouldn't see new features.


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
