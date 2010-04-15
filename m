From: James Braid <jamesb@loreland.org>
Subject: Re: grow fails with 2.6.34 git
Date: Thu, 15 Apr 2010 16:09:03 +0100
Message-ID: <hq7a6f$hqg$1@dough.gmane.org>
References: <hq5efu$mqb$1@dough.gmane.org> <20100415110401.22c7a6bf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415110401.22c7a6bf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/04/10 02:04, Neil Brown wrote:
> On Wed, 14 Apr 2010 23:10:06 +0100
> James Braid <jamesb@loreland.org> wrote:
>> # cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md4 : active raid6 sde[0] sdg[5](S) sdh[6](S) sdc[3] sdd[2] sdf[1]
>>        4395415488 blocks level 6, 64k chunk, algorithm 18 [5/4] [UUUU_]
> 
> So it has converted your RAID5 to RAID6 with a special layout which places
> all the Q blocks on the one disk.  That disk is missing.  So your data is
> still safe, but the layout is somewhat unorthodox, and it didn't grow to 6
> devices like you asked it to.

Yeah, I was a a bit confused as to why that didn't work.

>> After the grow failed, I stopped the array and restarted it. At that 
>> point it appears to be continuing with the grow process? Is this correct?
> ...
>> # cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md4 : active raid6 sde[0] sdh[5] sdg[6](S) sdc[3] sdd[2] sdf[1]
>>        4395415488 blocks level 6, 64k chunk, algorithm 18 [5/4] [UUUU_]
>>        [>....................]  recovery =  0.0% (147712/1465138496) 
>> finish=661.1min speed=36928K/sec
> 
> What is happening here is that the spare (sdh) is getting the Q blocks
> written to it.  When this completes you will have full 2-disk redundancy but
> the layout will not be optimal and the array wont be any bigger.
> To fix this you would:
> 
>   mdadm --grow --backup-file=/root/backup.md4 --raid-devices=6 \
>       --layout=normalise /dev/md4
> 
> Hopefully this will not hit the same problem that you hit before.

This seems to be working OK - thanks Neil! The man pages cover this
quite well too.

