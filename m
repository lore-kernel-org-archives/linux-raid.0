From: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.be>
Subject: Re: Does grub support sw raid1?
Date: Thu, 23 Mar 2006 17:33:15 +0100
Message-ID: <4422CDCB.4070104@cc.kuleuven.be>
References: <442020AD.7090902@cc.kuleuven.be> <44202F7A.80901@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44202F7A.80901@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, redhat-list@redhat.com
List-Id: linux-raid.ids

Thanks to all who confirmed that this should work, and gave pointers to=
=20
   more reading material.

=46urther investigation proved that the problem is caused by the Smart=20
Array Controllers that HP uses.  As these "Smart" controllers don't=20
allow for JBOD configs, I had configured each disk as RAID 0 at the=20
hardware level.  When I remove disk 0, the controller detects that it i=
s=20
not set up for fault tolerance, and fails the logical drive.
As they apparently will only boot from the first logical drive defined,=
=20
(which must have been the reason why I couldn't boot when I installed=20
Red Hat on drives in slots 2 and 3), you now need to go into the Smart=20
controller configuration utility, and delete the failed logical drive.
My 2nd disk was configured in logical drive 2, which now is at the top=20
of the list, and therefore can boot just fine.

I'm now struggling with getting the Smart Array controller to recognize=
=20
the replacement devive, but that would be a question for an HP/linux=20
mailing list.  I tried registering to=20
compaqandlinux-subscribe@van-dijk.net, which gets expanded to=20
compaqandlinux-subscribe@jedi.van-dijk.net, but that comes back with a=20
"user unknown in local recipient table".
Does anyone know of a good "linux on HP" mailinglist?

Kind regards,

Herta


Mike Hardy wrote:
> This works for me, there are several pages out there (I recall using =
the
> commands from a gentoo one most recently) that show the exact sequenc=
e
> of grub things you should do to get grub in the MBR of both disks.
>=20
> It sounds like your machine may not be set to boot off of anything ot=
her
> than that one disk though? Is that maybe a BIOS thing?
>=20
> I dunno, but I have definitely pulled a primary drive out of the syst=
em
> completely and booted off the second one, then had linux come up with
> (correctly) degraded arrays
>=20
> -Mike
>=20
> Herta Van den Eynde wrote:
>=20
>>(crossposted to linux-raid@vger.kernel.org and redhat-list@redhat.com=
)
>>(apologies for this, but this should have be operational last week)
>>
>>I installed Red Hat EL AS 4 on a HP Proliant DL380, and configured al=
l
>>system devices in software RAID 1.  I added an entry to grub.conf to
>>fallback to the second disk in case the first entry fails.  At bootti=
me,
>>booting from hd0 works fine.  As does booting from hd1.
>>
>>Until I physically remove hd0 from the system.
>>
>>I tried manually installing grub on hd1,
>>I added hd1 to the device.map and subsequently re-installed grub on i=
t,
>>I remapped hd0 to /dev/cciss/c0d1 and subsequently re-installed grub
>>all to no avail.
>>
>>I previously installed this while the devices were in slots 2 and 3. =
The
>>system wouldn't even boot then.  It looks as though booting from sw
>>RAID1 will only work when there's a valid device in slot 0.  Still
>>preferable over hw RAID1, but even better would be if this worked all
>>the way.
>>
>>Is this working for anyone?  Any idea what I may have overlooked?  An=
y
>>suggestions on how to debug this?
>>
>>Kind regards,
>>
>>Herta
>>
>>Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Herta Van den Eynde              -=3D- Toledo system management
K.U. Leuven - Ludit              -=3D- phone: +32 (0)16 322 166
                                  -=3D- 50=B051'27" N 004=B040'39" E

"Life on Earth may be expensive,
  but it comes with a free ride around the Sun."

Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
