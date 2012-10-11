From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: task xfssyncd blocked while raid5 was in recovery
Date: Thu, 11 Oct 2012 13:16:14 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1210111315110.21297@uplift.swm.pp.se>
References: <CACY-59dr2Gy5XgddD01yy+c5ktCgYvOdU9w-VX8GK27bvbbgRA@mail.gmail.com> <507561EB.1050308@hardwarefreak.com> <alpine.DEB.2.00.1210110810210.21297@uplift.swm.pp.se> <5076A726.3070002@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5076A726.3070002@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 11 Oct 2012, Stan Hoeppner wrote:

>> Doesn't he still have 3 good drives? So since sdb was failed, there
>> would be no reason for sdb to cause blocking or writes to the (now
>> degraded) raid5? OP said he saw write IO errors to the array (?), which
>> I thought was strange.
>
> I think the more important question is, why was the OP writing to a
> filesystem on a small RAID5 array while it was doing a rebuild?

Why is that an important question?

Even if he was, should there ever be IO write errors on it, even if it has 
a lot of load on it?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
