From: Oliver Paulus <oliver@code-project.org>
Subject: raid superblock checksum problem
Date: Wed, 27 Sep 2006 08:22:51 +0200
Message-ID: <20060927082251.z2se9ux33pc0o40k@raudies.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a SIL3512 S-ATA controller. I have tried to setup a raid1 with 2 discs.
The problem I have is that the checksum of both drives is never correct (I used
mdadm --examine /dev/sdxx). If I assemble a new raid with 2 partitions and the
resync is finished the checksum on the two partitions is wrong. With "mdadm
--detail /dev/md0" I get the state "active sync" of the raid device.

I cannot use the created raid device as "/" partition. I get the following error
in dmesg:
"invalid superblock checksum on sda1"
"invalid superblock checksum on sdb1"

I have used the Debian Etch installer (Weekly - from 21.Sept).

Regards
Oliver Paulus

