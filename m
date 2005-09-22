From: Farkas Levente <lfarkas@bppiac.hu>
Subject: raid5 or raid6 and the maximum size
Date: Thu, 22 Sep 2005 15:11:49 +0200
Message-ID: <4332AD95.1080904@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,
i'd like to know the current state of the raid6 driver. we are now 
switching one of our server from 8 x 200GB to 8 x 300GB(or 400GB).
so which is the better if we use:
- 7 x 300GB in raid5 and one 300GB spare or
- 8 x 300GB in raid6?
it seems the same to me since both case we can get two disk faild and 
the same capacity. so why we choose raid6 over raid5 (when raid5 seems 
to be more stable then raid6)?
another question is there any upper limit for one raid5(6) partition? i 
read 1TB and 2TB too (although we already have a raid5 which is larger 
then 1TB). these are still real limit? or what is the current limit?
thank you for your help in advance.
yours.

-- 
   Levente                               "Si vis pacem para bellum!"

