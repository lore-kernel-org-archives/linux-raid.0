From: "Basheer Noorgat" <bn@nmcexquisite.com>
Subject: Software Raid Problem -  Device or resource busy.
Date: Wed, 01 Aug 2007 18:04:42 +0200
Message-ID: <46B0CB3A.22869.222CF08@bn.nmcexquisite.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-description: Mail message body
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Re: Software Raid Problem
----------------------------------------

Background
------------------------------------------
OS= Opensuse 10.2
2 X 250gb Sata drives

Drive 1
----------
/dev/sda1 = swap
/dev/sda2 = linux raid   (os & data is here)
/dev/sda3 = linux raid  

Drive 2
----------
/dev/sdb1 = swap
/dev/sdb2 = linux resiser
/dev/sdb3 = linux reiser
---------------------------------------------------------------

Using mdadm I managed to create /dev/md0 in raid 1 (mirror). 
/dev/sda3 & /dev/sdb3 where added to this set.

Good so far....now for the problem....

Problems Area
-----------------------
Using mdadm I  failed to create /dev/md1 in raid 1 (mirror). 
/dev/sda2 & /dev/sdb2 where part of  this set.
I get this error: mdadm: cannot open device /dev/sda2: Device or 
resource busy.

I booted from rescue CD, and ran the mdam command to create /dev/md1 
... and it worked! I let the raid sync.

When I reboot, I get this error:

mdadm: cannot open device /dev/sda2: Device or resource busy.
mdadm: /dev/sda2 has no superblock - assembly aborted

How to do I solve this?

Your help will be appreciated.

Regards


Basheer Noorgat 
NMC EXQUISITE
23 Bauhinia Rd., Stanger, 4450, South Africa
P.O.Box 2449, Stanger, 4450, South Africa
Ph: (032) 551 3300     Fax: (032) 551 4414 
Cell: 082 5510 227      Int. Code: +27 (32)
Web: http://www.nmcexquisite.com
Skype: noorgat.b



