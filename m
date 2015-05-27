From: Michael Munger <michael.munger@gmail.com>
Subject: Which physical device failed?
Date: Wed, 27 May 2015 08:04:11 -0400
Message-ID: <5565B2BB.5090701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In a degraded array (4 disks: sdb,sdc,sdd,sde in  RAID 5). One of my disks
failed (sdc).

Is there an easy way to figure out which PHYSICAL disk that is? I have
always just unplugged the sata cables one at a time to map it, but it
occurs to me that the drives may be enumerated in order (SATA port0 is sda,
SATA port 1 is sdb, etc...)

Or, does the OS have access to serial numbers, etc...?

I have to guide someone through a drive replacement on the phone, and it
would be great if I could tell them exactly which drive to swap out...

Thanks in advance,
Michael

