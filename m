From: Chris Hirsch <chris@base2technology.com>
Subject: Re: 15% used but "No space left on Device"
Date: Wed, 19 Nov 2003 07:23:23 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FBB7CDB.4050505@base2technology.com>
References: <Pine.LNX.4.56.0311161309010.12003@nemesis.cs.yorku.ca> <3FB7CE28.6090100@eglifamily.dnsalias.net> <Pine.LNX.4.56.0311161816320.12003@nemesis.cs.yorku.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0311161816320.12003@nemesis.cs.yorku.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>attempt to access beyond end of device
>09:00: rw=0, want=707399196, limit=488396800
>
>Weird.  I try using display on that file and sometimes it dies and
>sometimes it doesn't.  Very unpredictable.
>
>Why would the system 'think' that I'm trying to access outside of my disk
>when the file exists and is the correct size?
>  
>
Just to warn you I saw this exact error message...I'm running a RAID-1 
on a RH 8 box. Eventually the entire partition corrupted itself and I 
lost it all...so you may want to make sure you have a good backup of 
that partition. I haven't had the time to figure out exactly what went 
wrong. I was doing a RAID-1,LVM,ReiesrFS.

On that same note I have like 4 other partitions on that same RAID-1 and 
I haven't seen any other problems...so I was thinking it was was either 
LVM or ReiserFS or me :-)

Chris

-- 
A:      To be or not to be.                                               
Q:      What is the square root of 4b^2?


http://ccicolorado.org
Exceptional Dogs for Exceptional People - Help Out Today!



