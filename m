From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Multipath problem in a SAN enviromnent
Date: Wed, 11 Jun 2003 12:27:10 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE7585E.45D851CE@SteelEye.com>
References: <02d201c33023$13fd45a0$3351960a@EEL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Ionut Nistor <ionut@modulo.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ionut Nistor wrote:

> So scsi1, bus0, target0, lun2 is now 8,16 instead of 8,32
> 
> However, the raid superblock still has 8,32 in it - this confuses
> multipath 

One way to get around this problem is to use non-persistent superblocks
for your arrays and just re-create them at bootup time by calling mkraid
(or mdadm) after you've correctly identified (using WWID or similar)
which devices belong to each particular raid set.

--
Paul
