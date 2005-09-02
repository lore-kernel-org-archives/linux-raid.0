From: Claas Hilbrecht <claas+maillinglists.linux-raid@jucs-kramkiste.de>
Subject: Re: MD or MDADM bug?
Date: Fri, 02 Sep 2005 08:42:30 +0200
Message-ID: <EA0E31E2DD4FA4EEF92B6D2F@[192.168.1.22]>
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

Maybe you didn't notice that but there are two recent threads that reports 
nearly the same problem. Look at the posts:

08.08.2005: How to recover a multiple raid5 disk failure with mdadm?
30.08.2005: 2 partition kicked from 6 raid5

And as far as I can see there is no solution yet. Maybe it's faster to 
restore the data from the backup instead of hoping someone can help you. 
But I really think a howto with "how to replace a multiple raid5 disk 
failure" is badly needed. Sometimes it happens that there is a bad cable or 
a problem on a resync. And the users knows that the data is good or at 
least most of the files are.

-- 
 Claas Hilbrecht
 http://www.jucs-kramkiste.de


