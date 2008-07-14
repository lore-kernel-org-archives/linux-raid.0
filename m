From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: Debugging new HW  XOR engine driver
Date: Mon, 14 Jul 2008 11:26:02 -0700 (PDT)
Message-ID: <961575.29492.qm@web81301.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am new to this mailing list. I am working on adding driver for HW acc=
elerated XOR engine. I am able to get XOR engine working and created AD=
MA interface . I am able to create RAID-5 using mdadm. After creating f=
ilesystem, I tried to mount the /dev/md0 . It failied to mount saying t=
hat "ext3_check_descriptors: Block bitmap for group 384 not in group" .=
 For sure there is some thing wrong at driver level.=20
=A0 I used "dd" command to read/write to /dev/md0. It seems read/writes=
 are not a problem. When I do small file sizes of 10K , everything fine=
=2E When I write a file of size of 1MB or above seems to have issue. Lo=
oks like partial write fine too.
=A0 I am looking for the ways to debug the problem. Also looking for su=
ggestions from the people who developed HW accelerated drivers and the =
issue thy run into. Are the some tools to identify the corruptions.
Thanks in Advance.
--Tirumala

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
