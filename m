From: Victor Gregorio <victor@opsource.net>
Subject: MegaRaid 2002 Only Works on Install
Date: Thu, 01 Apr 2004 14:18:03 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406C951B.4050509@opsource.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.  We are trying to get the megaraid 2002 driver working on a Dell 
Poweredge system with RedHat ES 2.1.  The driver can be loaded properly 
on install via floppy.

Towards the end of installation when I <cntrl><alt><F2> and 'mkinitrd' 
as the Dell documentation instructs, I get a binary operator expected 
error on the megaraid_2002.o module.  I don't know why the Dell 
documentation asks that I make initrd since it is already available in 
/boot.

On boot, the system throws up a screenfull of unresolved symbol errors 
for megaraid_2002.o and then kernel panics because it can't mount /boot 
and sees no initrd.

How can the driver work during installation, but not at boot?  Any 
advice is appreciated.

Thank you, Victor.
