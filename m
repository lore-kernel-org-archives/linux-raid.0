From: Simon Jackson <sjackson@bluearc.com>
Subject: Migrating RAID 1 volumes to Dual ported disks.
Date: Tue, 3 Nov 2009 16:01:54 +0000
Message-ID: <ABFC24E4C13D81489F7F624E14891C865AA4C65E@uk-ex-mbx1.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi.

I am currently using SATA drives in a RAID 1 configuration.  I am looking to use SAS drives instead of SATA.  As my first experiment I have plugged my SAS drive into a system and I have noticed that Linux sees the individual ports on the device as separate devices, so I have /dev/sdc and /dev/sdd which are both the same physical device.

So if I have a system with 2 SAS drives I am going to have 4 devices representing the two physical drives.  So my question is how do I create RAID 1 sets for partitions on these types of drive?  

My existing system carves 3 RAID 1 volumes from a pair of drives.  How do I translate this to the dual port SAS devices? 

Thanks Simon.
