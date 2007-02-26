From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: trouble creating array
Date: Sun, 25 Feb 2007 19:13:26 -0800 (PST)
Message-ID: <82143.24412.qm@web55803.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I hadn't thought of that, but it doesn't seem to be it...

# pvs
  PV         VG         Fmt  Attr PSize  PFree=20
  /dev/hda2  VolGroup00 lvm2 a-   18.97G 32.00M

=46C6 created that for my / and /boot and swap... Thanks for the sugges=
tion tho - something I had not considered.


Graham


----- Original Message ----
=46rom: Mark Hahn <hahn@mcmaster.ca>
To: jahammonds prost <gmitch64@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Sunday, 25 February, 2007 10:01:06 PM
Subject: Re: trouble creating array


> Any ideas how to find out what has it open? I can happily write all o=
ver

I think I've heard of other cases like this where it's lvm that's=20
glommed onto the partition.  I don't use lvm, but perhaps 'lvdisplay'?


	=09
___________________________________________________________=20
All New Yahoo! Mail =96 Tired of unwanted email come-ons? Let our SpamG=
uard protect you. http://uk.docs.yahoo.com/nowyoucan.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
