From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: Re: Debugging new HW XOR engine driver
Date: Tue, 15 Jul 2008 13:19:55 -0700 (PDT)
Message-ID: <311346.67486.qm@web81308.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: thomas62186218@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dan,
=A0 440SPe was my refence driver . I am working new SOC with some modif=
ications to XOR engines. I have most of the stuff working like ADMA and=
 XOR(tested one block of data). When I use ADMA and SW XOR(with out=A0H=
W XOR) RAID-5 works fine.=A0=A0 =A0When combined ADMA + XOR , having is=
sues. =A0When I create a file system and try to mount it fails. Which c=
ould be becasue of some state problem in XOR calculations.
Is there any document about how=A0 full stripe write, partial stripe wr=
ites and recovery=A0 works in MD driver ?
Thanks,
Marri
=A0=20
=A0


----- Original Message ----
=46rom: Dan Williams <dan.j.williams@intel.com>
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: thomas62186218@aol.com; linux-raid@vger.kernel.org
Sent: Tuesday, July 15, 2008 11:34:48 AM
Subject: Re: Debugging new HW XOR engine driver

On Tue, Jul 15, 2008 at 9:59 AM, tirumalareddy marri
<tirumalareddymarri@yahoo.com> wrote:
> I am working AMCC powerPC based SoC. It has XOR engine built in the H=
W.

Is this related to the driver started here?

[PATCH] [PPC32]=A0 ADMA support for PPC 440SPe processors.
http://marc.info/?l=3Dlinux-raid&m=3D117400143317440&w=3D2

If so, that may be a better starting point.

--
Dan
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
