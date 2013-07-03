From: cvb@kruemel.org
Subject: Extending an existing RAID (10) array
Date: Wed, 03 Jul 2013 21:04:00 +0200
Message-ID: <987a86de2c602b7d79c3b926fdfced80@kruemel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I have a short and hopefully simple question: On

https://raid.wiki.kernel.org/index.php/Growing

there is a section on expanding existing partitions. Does the procedure 
described there also apply to RAID 10 arrays?

I'm asking, because the section above says explicitly that it only 
applies to RAID level 1/4/5/6 arrays. The section on extending 
partitions is silent on that point...

I have a RAID 10 (software) array here, consisting of 4 disks. As one 
of the disks is a bit flaky, I'm thinking of replacing the (all) disks, 
maybe with bigger ones - if that should work.

Thanks, Chris
