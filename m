From: "David F." <df7729@gmail.com>
Subject: Breaks LSI RAID on C600 chipset
Date: Fri, 3 Apr 2015 17:25:02 -0700
Message-ID: <CAGRSmLtoCz+wff+F=xnnusc5_bUYxWYT5V5iTncTnRfgRnTqtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Loading V3.3.2 Aug 2014 on an asus z9pa-u8 mobo, with the controller
in LSI RAID mode and configured using  RAID 1 via the BIOS, will break
the RAID.  (no longer configured as RAID).  All it takes is starting
mdadm which seems to work for that session but on reboot the RAID is
gone.  The z9pa-u8 uses the C602 intel chipset.

Customer reported same on what they called an Intel ESRT2 which
appears to use the same line C600 based chipset.  Not sure if in LSI
mode, but presume so.  That controller allows you to pick LSI mode,
Intel RAID mode, or just non RAID normal controller mode.

Unfortunately, mine is a production server so I can't do much testing
(even trying to load it will probably break it).  Not sure if you can
get your hands on one to test.   Loading using DMRAID worked okay
which is how I got around it.
