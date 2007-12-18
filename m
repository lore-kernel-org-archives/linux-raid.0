From: Norman Elton <normelton@gmail.com>
Subject: Raid over 48 disks
Date: Tue, 18 Dec 2007 12:29:27 -0500
Message-ID: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
Mime-Version: 1.0 (Apple Message framework v915)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We're investigating the possibility of running Linux (RHEL) on top of  
Sun's X4500 Thumper box:

http://www.sun.com/servers/x64/x4500/

Basically, it's a server with 48 SATA hard drives. No hardware RAID.  
It's designed for Sun's ZFS filesystem.

So... we're curious how Linux will handle such a beast. Has anyone run  
MD software RAID over so many disks? Then piled LVM/ext3 on top of  
that? Any suggestions?

Are we crazy to think this is even possible?

Thanks!

Norman Elton
