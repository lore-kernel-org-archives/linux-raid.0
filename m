From: "Dominik Kubla" <kubla@uni-mainz.de>
Subject: RE: Bug in multipath code (Linux 2.6.x) ?
Date: Tue, 13 Apr 2004 12:46:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <B7A4A15090CB1847A60B569AC92FB9B352D280@EXSTORE2.zdv.uni-mainz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Lars Marowsky-Bree <lmb@suse.de>, Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, khoddam@netz.klinik.uni-mainz.de
List-Id: linux-raid.ids

Unfortunately very little effort seems to be spent on documenting the f=
eatures of device-mapper and how to use them. I originally intended to =
use DM, but since i could not find any information on how to configure =
mirrored multipath devices i decided against it.

What is the word on MD and DM? I miss some sort of road map and a gener=
al overview (preferrably with executive summary). (I am willing to writ=
e one if i can find/get the necessary information.)

Regards,
  Dominik=20

-----Original Message-----
=46rom: Lars Marowsky-Bree [mailto:lmb@suse.de]=20
Sent: Tuesday, April 13, 2004 10:04 AM
To: Dominik Kubla; Neil Brown
Cc: Dominik Kubla; linux-raid@vger.kernel.org; khoddam@netz.klinik.uni-=
mainz.de
Subject: Re: Bug in multipath code (Linux 2.6.x) ?

On 2004-04-10T10:11:58,
   Dominik Kubla <dominik.kubla@uni-mainz.de> said:

> Understandable. Maybe the Linux SAN-Alliance should sponsor you a=20
> couple of HBAs and a JBOD... ;-)

A lot of work has gone into the Device-Mapper multipath target in 2.6; =
maybe you should look at that one.


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
