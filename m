From: thomas62186218@aol.com
Subject: md RAID 10 on Linux 2.6.20?
Date: Thu, 22 Nov 2007 22:09:27 -0500
Message-ID: <8C9FB9564550DC0-464-E73@FWM-D05.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I am running a home-grown Linux 2.6.20.11 SMP 64-bit build, and I am 
wondering if there is indeed a RAID 10 "personality" defined in md that 
can be implemented using mdadm. If so, is it available in 2.6.20.11, or 
is it in a later kernel version? In the past, to create RAID 10, I 
created RAID 1's and a RAID 0, so an 8 drive RAID 10 would actually 
consist of 5 md devices (four RAID 1's and one RAID 0). But if I could 
just use RAID 10 natively, and simply create one RAID 10, that would of 
course be better both in terms of management and probably performance I 
would guess. Is this possible?

Thanks in advance!

Best regards,
Thomas
________________________________________________________________________
Email and AIM finally together. You've gotta check out free AOL Mail! - 
http://mail.aol.com
