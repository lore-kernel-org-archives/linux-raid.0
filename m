From: Heinz Mauelshagen <mauelshagen@RedHat.com>
Subject: Re: 3ware and erroneous multipathing - duplicate serial numbers
	(was: 3ware and dmraid)
Date: Fri, 18 Jan 2008 13:33:58 +0100
Message-ID: <20080118123358.GA6311@redhat.com>
References: <A2C96114-A87C-493B-A94D-4DCC80A17F95@develooper.com> <34DD6926-09BB-40FE-995E-C0C6796FE89C@develooper.com>
Reply-To: mauelshagen@RedHat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <34DD6926-09BB-40FE-995E-C0C6796FE89C@develooper.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ask =?iso-8859-1?Q?Bj=F8rn?= Hansen <ask@develooper.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 18, 2008 at 03:23:24AM -0800, Ask Bj=F8rn Hansen wrote:
>
> On Jan 18, 2008, at 3:17 AM, Ask Bj=F8rn Hansen wrote:
>
> [ Uh, I just realized that I forgot to update the subject line as I f=
igured=20
> out what was going on; it's obviously not a software raid problem but=
 a=20
> multipath problem ]
>
> One of my boxes crashed (with a hardware error, I think - CPU and=20
> motherboard replacements are on their way).  I booted it up on a resc=
ue=20
> disk (Fedora 8) to let the software raid sync up.
>
> When it was running I noticed that one of the disks were listed as "d=
m-5"=20
> and ... uh-oh ... there was a disk missing.   I figured out that the=20
> multipath stuff for some reason had setup two of the disks as=20
> /dev/mapper/mpath0 and now md was syncing to this device.
>
> Much later I figured out that "dmraid -b" reported two of the disks a=
s=20
> being the same:

Looks like the md sync duplicated the metadata and dmraid just spots
that duplication. You gotta remove one of the duplicates to clean this =
up
but check first which to pick in case the sync was partial only.

Regards,
Heinz    -- The LVM Guy --


>
> /dev/sda:    976541696 total, "W553841781E0A2001842"
> /dev/sdb:    976773168 total, "V600VXZG000000000000"
> /dev/sdc:    586114704 total, "U1757241000000000000"
> /dev/sdd:    976773168 total, "U1907712000000000000"
> /dev/sde:    976773168 total, "U2133609000000000000"
> /dev/sdf:    976773168 total, "D2994402000000000000"
> /dev/sdg:    625140335 total, "U2130349000000000000"
> /dev/sdh:    976773168 total, "U1541228000000000000"
> /dev/sdi:    976771055 total, "W5267124000000000000"
> /dev/sdj:    976773168 total, "U1409513000000000000"
> /dev/sdk:    976773168 total, "U1409513000000000000"
>
> Any idea how this could happen?   All 11 disks are on a 3ware 9650=20
> controller (the first one is a "single" 3ware device, the rest are JB=
OD). =20
> I tried rebooting and booting on a Fedora 7 DVD with the same result.
>
> [ all this of course seems to have messed up my raid10 badly -- more =
on=20
> that tomorrow ]
>
>
> - ask
>
> --=20
> http://develooper.com/ - http://askask.com/
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 780339=
2
                                                  FAX   +49 2626 924446
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
