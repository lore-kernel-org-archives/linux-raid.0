From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: Re: Debugging new HW  XOR engine driver
Date: Tue, 15 Jul 2008 09:59:43 -0700 (PDT)
Message-ID: <817998.29129.qm@web81306.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am working AMCC powerPC based SoC. It has=A0XOR engine built in the H=
W.=A0=20
Thanks,
Marri

----- Original Message ----
=46rom: "thomas62186218@aol.com" <thomas62186218@aol.com>
To: tirumalareddymarri@yahoo.com; linux-raid@vger.kernel.org
Sent: Tuesday, July 15, 2008 9:35:15 AM
Subject: Re: Debugging new HW XOR engine driver

Regarding your HW XOR driver, is this for Intel x86 or some other=20
platform. I am assuming x86 since you did not mention another other=20
processor platform but in that case, what hardware are you using for=20
XOR?

-Thomas


-----Original Message-----
=46rom: tirumalareddy marri <tirumalareddymarri@yahoo.com>
To: linux-raid@vger.kernel.org
Sent: Mon, 14 Jul 2008 11:26 am
Subject: Debugging new HW=A0 XOR engine driver










I am new to this mailing list. I am working on adding driver for HW=20
accelerated
XOR engine. I am able to get XOR engine working and created ADMA=20
interface . I
am able to create RAID-5 using mdadm. After creating filesystem, I=20
tried to
mount the /dev/md0 . It failied to mount saying that=20
"ext3_check_descriptors:
Block bitmap for group 384 not in group" . For sure there is some thing=
=20
wrong at
driver level.
=A0 I used "dd" command to read/write to /dev/md0. It seems read/writes=
=20
are not a
problem. When I do small file sizes of 10K , everything fine. When I=20
write a
file of size of 1MB or above seems to have issue. Looks like partial=20
write fine
too.
=A0 I am looking for the ways to debug the problem. Also looking for=20
suggestions
from the people who developed HW accelerated drivers and the issue thy=20
run into.
Are the some tools to identify the corruptions.
Thanks in Advance.
--Tirumala

--
To unsubscribe from this list: send=3D2
0the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html





--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
