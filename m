From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: task xfssyncd blocked while raid5 was in recovery
Date: Thu, 11 Oct 2012 09:47:47 -0500
Message-ID: <5076DC13.2020408@hardwarefreak.com>
References: <CACY-59dr2Gy5XgddD01yy+c5ktCgYvOdU9w-VX8GK27bvbbgRA@mail.gmail.com> <507561EB.1050308@hardwarefreak.com> <alpine.DEB.2.00.1210110810210.21297@uplift.swm.pp.se> <5076A726.3070002@hardwarefreak.com>,  <alpine.DEB.2.00.1210111315110.21297@uplift.swm.pp.se> <201210112054336567511@meganovo.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201210112054336567511@meganovo.com>
Sender: linux-raid-owner@vger.kernel.org
To: hanguozhong <hanguozhong@meganovo.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/11/2012 7:54 AM, hanguozhong wrote:
>>> Doesn't he still have 3 good drives? So since sdb was failed, there
>>> would be no reason for sdb to cause blocking or writes to the (now
>>> degraded) raid5? OP said he saw write IO errors to the array (?), which
>>> I thought was strange.
>>
>> I think the more important question is, why was the OP writing to a
>> filesystem on a small RAID5 array while it was doing a rebuild?
> 
>>> Why is that an important question?
> 
>>> Even if he was, should there ever be IO write errors on it, even if it has 
>>> a lot of load on it?
> 
> The problem was, there was no response to my program any more after xfssyncd was blocked.
> And I could use "rm -rf /mnt/md127/*" to remove the datas in the raid5. 

Please always reply to the linux-raid list, not to individual subscribers.

None of the above really matters at this point.  We know you have one
disk with at least one bad sector which isn't being reassigned for some
reason.  We know that the error recovery procedure in the drive and the
block layer was causing problems.  We also know you were generating a
non-trivial amount of IO on the array with a rebuild and application
write load when xfssyncd blocked.

It seems your application was likely doing sync, fsync, or fdatasync
operations.  Writes to the XFS journal are always synchronous barrier
writes, so if you were running a metadata heavy benchmark program you
were issuing lots of fsyncs.  It seems that due to the underlying IO
problems, xfssyncd was blocking on ack from the fsyncs.  If that's not
the case, then you're hitting one of the XFS bugs I mentioned that have
already been fixed in newer kernels.

Thus, your solution is:

1.  Fix or replace the drive with the bad sector(s)
2.  Update to a 3.x series kernel

Discussing anything else before you complete these tasks is a waste of
keystrokes, yours and ours.

-- 
Stan

