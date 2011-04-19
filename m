From: David Brown <david@westcontrol.com>
Subject: Direct disk access on IBM Server
Date: Tue, 19 Apr 2011 15:21:39 +0200
Message-ID: <iok28i$tp6$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have recently got an IBM x3650 M3 server, which has a "Serveraid 
M5014" raid controller.  Booting from a Linux CD (system rescue CD) and 
running lspci identifies this raid controller as:

LSI Logic/Symbus Logic Megaraid SAS 2108 [Liberator] (rev 03)

The controller works fine for hardware raid - I can open its bios setup 
utility, and set up a RAID5 (or whatever) with the disks I have.  The OS 
then just sees a single virtual disk.

But I would like direct access to the sata drives - I want to set up 
mdadm raid, under my own control.  As far as I can see, there is no way 
to put this controller into "JBOD" or "direct access" mode of any sort.

Does anyone here have experience with this card, or can give me any hints?

The only idea I have at the moment is to put each disk within its own 
single-disk RAID 0 set, but then I don't get sata hot-swap 
functionality, SMART, hddtemp, etc.

Thanks for any clues or hints,

David

