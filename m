From: Chris Hirsch <chris@base2technology.com>
Subject: RAID5 problem with multiple Promise PDC20269 controllers
Date: Mon, 28 Oct 2002 08:17:14 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DBD54FA.20709@base2technology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is probably more of a hardware question than RAID but since there 
has to be somebody in the same boat as myself....

I'm trying to do a RAID5 setup with 3 IDE disks connected to IDE1/IDE2 
on a Promise  ULTRA133 TX2. Fine..works great with only two disks. So I 
bring in my 3rd disk on the second PDC20269 and I get kernel lockups and 
fun stuff when the array tries to rebuild or activate. I've tried deja 
and there seems to be some issues with multiple cards but I can't seem 
to find any resolutions. This is a RH 8.0 box using 2.4.18.

Thanks for any help!
Chris


-- 
Broken promises don't upset me. I just think, why did they believe me?

