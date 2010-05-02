From: MRK <mrk@shiftmail.org>
Subject: Re: Suggestion needed for fixing RAID6
Date: Mon, 03 May 2010 01:05:05 +0200
Message-ID: <4BDE0521.3080508@shiftmail.org>
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
 <12cf01cae911$f0d92940$0400a8c0@dcccs> <4BDC6217.9000209@shiftmail.org>
 <154b01cae977$6e09da80$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <154b01cae977$6e09da80$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/01/2010 11:44 PM, Janos Haar wrote:
>
> But you are right, because the sync_min option not works for 
> rebuilding disks, only for resyncing. (it is too smart to do the trick 
> for me)
>
>> I think... unless bitmaps really do some magic in this, flagging the 
>> newly introduced disk as more recent than parity data... but do they 
>> really do this? people correct me if I'm wrong.
>
> Bitmap manipulation should work.
> I think i know how to do that, but the data is more important than try 
> it on my own.
> I want to wait until somebody support this.
> ... or somebody have another good idea?

Firstly: do you have any backup of your data? If not, before doing any 
experiment I suggest that you back up important stuff. This can be done 
with rsync, and reassembling the array every time it goes down. I 
suggest to put the array in readonly mode (mdadm --readonly /dev/md3): 
this should prevent resyncs from starting automatically, and AFAIR even 
prevent drives being dropped because of read errors (but you can't use 
it during resyncs or rebuilds). Resyncs are bad because they will 
eventually bring down your array. Don't use DM when doing this.

Now, for the real thing, instead of experimenting with bitmaps, I 
suggest you try and see if the normal MD resync works now. If that works 
then you can do the normal rebuild.

*Pls note that: DM should not be needed!* - I know that you have tried 
resyncing with DM COW under MD and that one doesn't work well in this 
case, but in fact DM should not be needed.

We pointed you to DM around Apr 23rd because at that time we thought 
that your drives were dropping for uncorrectable read error, but we had 
guessed wrong.
The general MD phylosophy is that if there is enough parity 
informations, drives are not dropped just for a read error. Upon read 
error MD recomputes the value of the sector from the parity information, 
and then it attempts rewriting the block in place. During this rewrite 
the drive performs a reallocation, moving the block to a hidden spare 
region. If this rewrite fails it means that the drive is out of spare 
sectors and this is considered to be a major failure for MD, and only at 
that point the drive is dropped.
So we thought this was the reason also in your case, but we were wrong, 
in your case it was because of an MD bug, which is the one for which I 
submitted the patch.

So it should work now (without DM). And I think this is the safest thing 
you can try. Having a backup is always better though.

So start the resync without DM and see if it goes through to the end 
without dropping drives. You can use sync_min to cut the dead times.

For max safety you could first try resyncing only one chunk from the 
region of the damaged sectors, so to provoke only a minimum amount of 
rewrites. Set the sync_min to the location of the errors, and sync_max 
to just one chunk above. See what happens...
If it rewrites correctly and the drive is not dropped, then run "check" 
again on the same region and see if "cat /sys/block/md3/md/mismatch_cnt" 
still returns zero (or the value it was before the rewrite). If it is 
zero (or anyway has not changed value) it means the block was really 
rewritten with the correct value: recovery of one sector really works 
for raid6 in singly-degraded state. Then the procedure is safe, as far 
as I understand, and you can go ahead on the other chunks.
When all damaged sectors are reallocated, there are no more read errors, 
and the mismatch_cnt is still at zero, you can go ahead replacing the 
defective drive.

There are a few reasons that can still make the resync fail if we are 
really unlucky, but dmesg should point us to the right direction in that 
case.
Also remember that the patch still needs testing... currently it is not 
really tested because DM drops the drive before MD. We would need to 
know if raid6 is behaving like a raid6 now or it's still behaving like a 
raid5...
Thank you

