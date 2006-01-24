From: PFC <lists@peufeu.com>
Subject: Re: multiple Sata SATAII 150, TX4  - how to tell which drive is which? headaches galore!
Date: Tue, 24 Jan 2006 10:54:19 +0100
Message-ID: <op.s3vm4tckcigqcu@apollo13>
References: <200601230336.55220.mlaks@verizon.net> <op.s3ty89rfcigqcu@apollo13> <43D53AEC.7060302@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D53AEC.7060302@xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>
Cc: Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Does SMART work for your SATA drives?  Without SMART support I don't  
> really want to get any more SATA drives.  Mine reports this:

	The feature should come some day. This is quite vital for RAID arrays...
	Meanwhile, get the same error as you :

--------------------

SATA disks accessed via libata are not currently supported by
smartmontools. When libata is given an ATA pass-thru ioctl() then an
additional '-d libata' device type will be added to smartmontools.


smartmontools release 5.33 dated 2004/09/10 at 04:11:35 UTC
smartmontools build host: x86_64-pc-linux-gnu
smartmontools build configured: 2005/12/11 13:39:15 UTC
smartctl compile dated Dec 11 2005 at 14:39:26

2.6.15-gentoo
