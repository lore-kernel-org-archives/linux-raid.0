From: thomas62186218@aol.com
Subject: Re: Whole drives or Only partitions for mdadm software RAIDs?
Date: Mon, 30 Jun 2008 15:58:21 -0400
Message-ID: <8CAA902C7CC8B09-594-8CF@webmail-nb10.sysops.aol.com>
References: <8CAA8FD62E1D4D0-594-672@webmail-nb10.sysops.aol.com> <alpine.DEB.1.10.0806301549580.4791@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0806301549580.4791@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: jpiszcz@lucidpixels.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks Justin. If that's the only risk, I'll go with full devices. This=
=20
will ultimately be a headless system with a separate boot drive and=20
only administered by me and used internally, so I'll be careful. :-)

Many thanks!
-Thomas

-----Original Message-----
=46rom: Justin Piszcz <jpiszcz@lucidpixels.com>
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
Sent: Mon, 30 Jun 2008 12:50 pm
Subject: Re: Whole drives or Only partitions for mdadm software RAIDs?









=C2=A0

On Mon, 30 Jun 2008, thomas62186218@aol.com wrote:=C2=A0
=C2=A0

> Hi all,=C2=A0

>=C2=A0

> I have a simple question:=C2=A0

>=C2=A0

> Is there any problem using the full hard drive (/dev/sdb, /dev/sdc,=20
etc) as
> opposed to partitions (/dev/sdb1, /dev/sdc1, etc) when creating=20
software
> RAIDs? I'd rather commit the full device to the RAID since I am=20
certain I
> won't use it for anything else, and I am scripting this so I don't=20
want to
> have to fdisk every drive before creating a RAID...that would take=20
far too
> much time. Most mdadm documentation always refers to partitions=20
rather than
> full devices, so I wanted to make sure it was indeed OK to use full=20
devices.=C2=A0

>=C2=A0

> Please let me know. Thank you all!=C2=A0

>=C2=A0

> Thanks!=C2=A0

> Thomas=C2=A0

> --=C2=A0

> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
=20
in=C2=A0

> the body of a message to majordomo@vger.kernel.org=C2=A0

> More majordomo info at  http://vger.kernel.org/majordomo-info.html=C2=
=A0

>=C2=A0
=C2=A0

Best to use partitions, so if you over-write the MBR  of the drive it
won't mess up the RAID (e.g., run LILO on a raid volume =3D> oops! but =
if
its a partition, no problems)..=C2=A0
=C2=A0

Justin.=C2=A0

--=C2=A0

To unsubscribe from this list: send the line "unsubscribe linux-raid"=20
in=C2=A0

the body of a message to majordomo@vger.kernel.org=C2=A0

More majordomo info at  http://vger.kernel.org/majordomo-info.html=C2=A0





--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
