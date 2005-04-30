From: Tyler <tyler@dtbb.net>
Subject: How to increase the max MD devices beyond 27 drives/devices? And
 more info on md bitmaps?
Date: Sat, 30 Apr 2005 04:09:17 -0700
Message-ID: <4273675D.7020104@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I believe I read somewhere (mdadm 2.0-devel docs) that support for 
greater than 27 MD devices is in amongst the MD bitmap patches in the 
-mm tree.  Could someone point me towards just the patches needed for 
greater than 27 MD devices, and possibly some more information on the 
bitmap features, along with documentation?  I've got the 2.6.11.7 kernel 
running right now, i'm assuming that isn't enough, because current 
attempts to create an array with greater than 27 drives still fails 
(even using mdadm-2.0-devel).

Thanks,
Tyler Guthrie.
