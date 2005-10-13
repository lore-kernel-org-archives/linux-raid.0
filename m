From: =?ISO-8859-2?Q?Makovecz_=C1d=E1m?= <adam@makovecz.hu>
Subject: RAID
Date: Thu, 13 Oct 2005 22:18:53 +0200
Message-ID: <434EC12D.4020300@makovecz.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

sorry for disturbation, but I'm afraid of my server data lost. Could you 
help me a little? I didn't find any how-tos about this situtation. I 
have two server and I made both of them RAID1 with raidtools2 and mdadm 
0.9. No I upgraded the servers but thay said the mdadm new version is 
different then tha created raid ones. Just a litte note in the 
installation that I have to turn off the autoraid and after it take the 
"mdadm --zero-superblock...." command. But I don't know how it works 
on-the fly. The upgrade delet the raidstart and stop commands, so I 
can't stop the raid for theese commands.
1. What should I do? Is somewhere any hos to to this upgrade?
2. One of the servers the raid is the root device. How can I upgrade this?

Thanks for your fast help.

A beginner RAID devil...
Adam Makovecz

