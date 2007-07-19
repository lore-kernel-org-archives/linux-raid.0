From: "J. Hart" <af804@bfn.org>
Subject: 2.6.19-rc5: Can't get built-in raid support, modular works correctly
Date: Thu, 19 Jul 2007 22:54:04 +0900
Message-ID: <469F6CFC.5050700@bfn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When I configure a 2.6.19-rc5 linux kernel for "built-in" raid support,  
I do not get the expected /proc/mdstat entry.  I set the following 
kernel parameters for this :

CONFIG_MD=Y
BLK_DEV_MD=y
MD_RAID0=y

When I configure the kernel for modular raid support in otherwise 
identical fashion, I do get the expected /proc/mdstat "file".  I have no 
difficulty configuring "built-in" support under kernel 2.6.13 on another 
32 bit X86 based system with IDE drives.  The system I am trying to set 
up raid support for is X86_64 based, and has only SATA drives.  I have 
not configured IDE support for it.   Any ideas would be greatly appreciated.

