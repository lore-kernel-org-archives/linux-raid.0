From: Anshuman Aggarwal <anshuman@brillgene.com>
Subject: Convert RAID 5 to RAID 6 while reducing array size
Date: Sun, 8 May 2011 01:20:06 +0530
Message-ID: <5D271CD8-AE79-441F-A6FA-AF0E5D481E4D@brillgene.com>
References: <34905057-B75E-4721-B6D2-7B9FA733BCA8@brillgene.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <34905057-B75E-4721-B6D2-7B9FA733BCA8@brillgene.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I'm trying to convert a 6 device raid5 into a raid6. The 6th device was added into the Raid 5 by mistake instead of a grow operation to convert it into a RAID 6. As such the md device is not being used beyond the size that it had when it was a 5 device raid5.

Can this be done in a single grow step by specifying the reduced size (--array-size=xx) and new layout (l=6)? 

Thanks,
Anshu