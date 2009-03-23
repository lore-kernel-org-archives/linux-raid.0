From: Erik Boettcher <tehfoo@gmail.com>
Subject: Bad news after raid-5 recovery
Date: Sun, 22 Mar 2009 21:59:10 -0400
Message-ID: <125ed8800903221859s69a92f86l2848ad177be1f519@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok so the circumstances of the raid-5 array failing were odd --
related to an MCE caused by an issue with the chipset...  After
recovering the array, I find large sections of useful data.. but the
filesystems are junk!  I am using ext3 on top of LVM2 on top of
software raid-5...
Can anyone point me to programs that can assist me in recovering my
data?  All that comes to my mind is ext3grep.  I have yet to write
anything, and I find it odd that the superblocks and journals of all 7
logical volumes are messed up.
