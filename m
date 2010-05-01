From: MRK <mrk@shiftmail.org>
Subject: Re: Suggestion needed for fixing RAID6
Date: Sat, 01 May 2010 19:17:11 +0200
Message-ID: <4BDC6217.9000209@shiftmail.org>
References: <626601cae203$dae35030$0400a8c0@dcccs>
 <20100423065143.GA17743@maude.comedia.it>
 <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org>
 <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org>
 <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org>
 <7a3e01cae53f$684122c0$0400a8c0@dcccs> <4BD5C51E.9040207@shiftmail.org>
 <80a201cae621$684daa30$0400a8c0@dcccs> <4BD76CF6.5020804@shiftmail.org>
 <20100428113732.03486490@notabene.brown> <4BD830B0.1080406@shiftmail.org>
 <025e01cae6d7$30bb7870$0400a8c0@dcccs> <4BD843D4.7030700@shiftmail.org>
 <062001cae771$545e0910$0400a8c0@dcccs> <4BD9A41E.9050009@shiftmail.org>
 <0c1201cae7e0$01f9a930$0400a8c0@dcccs> <4BDA0F88.70907@shiftmail.org>
 <0d6401cae82c$da8b5590$0400a8c0@dcccs> <4BDB6DB6.5020306@shiftmail.org>
 <12cf01cae911$f0d92940$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <12cf01cae911$f0d92940$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/01/2010 11:37 AM, Janos Haar wrote:
> Whoever, the sync_min option generally solves my problem, becasue i 
> can build up the missing disk from the 90% wich is good enough for me. :-)

Are you sure? How do you do that?
Resyncing a specific part is easy, replicating to a spare a specific 
part is not. If the disk you want to replace was 100% made of parity 
data that would be easy, you do that with a resync after replacing the 
disk, maybe multiple resyncs region by region, but in your case it is 
not made of only parity data. Only raid3 and 4 separate parity data from 
actual data, raid6 instead finely interleaves them.
If you are thinking about replacing a disk with a new one (full of 
zeroes) and then resyncing manually region by region, you will destroy 
your data. Because in those chunks where the new disk acts as "actual 
data" the parity will be recomputed based on your newly introduced 
zeroes, and it will overwrite the parity data you had on the good disks, 
making recovery impossible from that point on.
You really need to do the replication to a spare as a single step, from 
the beginning to the end. You cannot use sync_min and sync_max for that 
purpose.
I think... unless bitmaps really do some magic in this, flagging the 
newly introduced disk as more recent than parity data... but do they 
really do this? people correct me if I'm wrong.
