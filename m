From: koti <satha_koti@yahoo.co.in>
Subject: Request on RAID10
Date: Sat, 26 Jun 2010 16:56:33 +0000 (UTC)
Message-ID: <loom.20100626T184818-212@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everyone,

We created RAID10 array on 4 disks (physically we had 3 1TB disks as test case
we created 350GB partitions). We got a hang while we are doing the following:
1) remove the disk and add this again. Doing this in while loop.
2) While doing the above, simultaneously read and write on the same array.

At some point of time the recovery going to hang, then the array was not
operational, we are using kernel 2.6.27.

I am new to use the RAID 10 array. Is this scenario was correct? if it is then
what might be the problem, can any body suggest me and direct in proper way. It
is very much useful for proceed further on this.

Thanks,
Koti.

