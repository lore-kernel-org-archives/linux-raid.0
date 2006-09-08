From: Richard Scobie <richard@sauce.co.nz>
Subject: UUID's
Date: Sat, 09 Sep 2006 10:08:06 +1200
Message-ID: <4501E9C6.10403@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If I have specified an array in mdadm.conf using UUID's:

ARRAY /dev/md0 UUID=3aaa0122:29827cfa:5331ad66:ca767371

and I replace a failed drive in the array, will the new drive be given 
the previous UUID, or do I need to upate the mdadm.conf entry?

Regards,

Richard
