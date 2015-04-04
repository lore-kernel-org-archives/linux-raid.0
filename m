From: "John Stoffel" <john@stoffel.org>
Subject: Re: Breaks LSI RAID on C600 chipset
Date: Fri, 3 Apr 2015 21:47:30 -0400
Message-ID: <21791.17074.357416.218211@quad.stoffel.home>
References: <CAGRSmLtoCz+wff+F=xnnusc5_bUYxWYT5V5iTncTnRfgRnTqtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLtoCz+wff+F=xnnusc5_bUYxWYT5V5iTncTnRfgRnTqtg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


David> Loading V3.3.2 Aug 2014 on an asus z9pa-u8 mobo, with the
David> controller in LSI RAID mode and configured using RAID 1 via the
David> BIOS, will break the RAID.  (no longer configured as RAID).
David> All it takes is starting mdadm which seems to work for that
David> session but on reboot the RAID is gone.  The z9pa-u8 uses the
David> C602 intel chipset.

Which version of Linux kernel and disto are you using?  

David> Customer reported same on what they called an Intel ESRT2 which
David> appears to use the same line C600 based chipset.  Not sure if
David> in LSI mode, but presume so.  That controller allows you to
David> pick LSI mode, Intel RAID mode, or just non RAID normal
David> controller mode.

David> Unfortunately, mine is a production server so I can't do much testing
David> (even trying to load it will probably break it).  Not sure if you can
David> get your hands on one to test.   Loading using DMRAID worked okay
David> which is how I got around it.

Can you please give us the exact steps you took, and the output at
each step?  Also, which version of mdadm are you running which does
NOT break things?  That would be good to know.

The output of 'cat /proc/mdstat', 'mdadm --detail /dev/md*' and 'mdadm
-E /dev/sd?e' for each device in the various raid arrays.

If you start then stop the new mdadm, do you see differences when you
then use the old, working mdadm to examine the various devices?  

Basically, we need lots more information here to help.

John
