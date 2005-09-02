From: Claas Hilbrecht <claas+maillinglists.linux-raid@jucs-kramkiste.de>
Subject: Re: MD or MDADM bug?
Date: Fri, 02 Sep 2005 08:36:14 +0200
Message-ID: <BEA93B8227B8CC1E8C8C643F@[192.168.1.22]>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Am Donnerstag, 1. September 2005 17:26 -0400 "David M. Strang" 
<dstrang@shellpower.net> schrieb:

> The problem is; my array is now 26 of 28 disks -- /dev/sdm *IS* bad; it
[...]
> What can I do? I don't believe this is working as intended.

I think the posts:

08.08.2005: How to recover a multiple raid5 disk failure with mdadm?
30.08.2005: 2 partition kicked from 6 raid5

describe the same problem. And it seems that no one was able to help. I 
hope you can rebuild your drive but I think you should use the backup if 
you need a quick solution. And indeed I think a "howto resolve a multiple 
raid5 disk failure" would be a good thing. Sometimes the problems are a 
faulty bus/cable and one knows that most (or even all) data is good.

-- 
 Claas Hilbrecht
 http://www.jucs-kramkiste.de


