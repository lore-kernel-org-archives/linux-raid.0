From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: making raid5 more robust against block errors
Date: Thu, 30 Mar 2006 08:53:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0603300849110.30836@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Is there any work going on to handle readerrors on a raid5 disk being 
handled by recreating the faulty block from the other disks and just 
rewriting the block, instead of kicking the disk out?

I've problems on several occasions where two disks in a raid5 will have 
single sector errors and thus it's impossible (afaik) to get the array up 
and running without a lot of manual intervention and likely data loss, 
when the information needed to get the array up and running without 
dataloss is actually there.

I know this has been discussed before (I've been in these discussions 
myself), just wanted to know if this resulted in any improvement?

Right now I am more prone to using 3ware hw-raid rather than sw-raid due 
to this, as it will do the above and handle the read error gracefully. The 
data integrity is more important than write speed (where sw-raid excels) 
for me.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
