From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Expanding RAID array?
Date: Tue, 17 Jan 2006 10:43:44 +0400
Message-ID: <43CC9220.8000800@wasp.net.au>
References: <1137424449.3953.38.camel@kenny> <17356.8228.325002.652805@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17356.8228.325002.652805@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: John Rowe <rowe@excc.ex.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

> - add disks to convert to raid6.
>     I don't think this is possible, but you should check the latest
>     raid reconfig.

It's not. I started work on it Feb last year but then real life got in the way again.
In the longer term, I think raidreconf as it stands is going to die (mainly because it's 
infrastructure relies on the old raidtab architecture). I thought about perhaps porting it as an 
addon to mdadm, but then I ran out of drives/machines/time to test it on.

>     Might be supported online with a limited raid6 in which the Q
>     syndrome (second 'parity' block) isn't rotated among disks.

In theory I would have thought it not that much different than a raid-5 expand, just inserting an 
extra block for the Q syndrome.

> - status of RAID6
>     I believe it is as stable/reliable as raid5.

Mine has been running since Feb last year with fairly moderate use and no hiccups.
I have just upgraded to the latest 2.6.15-git on that machine to give some of the newer raid patches 
(like check & repair) a whirl. Seems fairly solid.

Let's say I've never had any raid-6 related data loss, or even near misses, but it has saved my 
bacon in 2 dual drive failures in the last year.

Oh, and the new read and check code (rather than just rebuild the parity blocks) shaves about 1 hour 
of what was an 11 hour rebuild time on this particular raid-6. Thanks Neil!

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
