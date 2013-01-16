From: EJ Vincent <ej@ejane.org>
Subject: Re: Suboptimal raid6 linear read speed
Date: Wed, 16 Jan 2013 15:40:11 -0500
Message-ID: <50F7102B.3030307@ejane.org>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <20130115170937.GA8831@kevin> <20130115195707.GA30921@www5.open-std.org> <20130116044335.GA10165@kevin> <20130116093651.GB1069@www5.open-std.org> <20130116160957.GB10165@kevin>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130116160957.GB10165@kevin>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/16/2013 11:09 AM, Charles Polisher wrote:
> keld@keldix.com wrote:
>> Hi Charles
>>
>> It really does not show below which layout you use for RAID10. This is quite
>> important as the different layouts of RAID10 have quite different
>> performance characteristics. The 'far' layout tends to be the fastest.
>> Which command did you use to create the RAID10 array?
>   
>
> mdadm --create /dev/md1 --chunk=64 --level=10 \
>        --raid-devices=8 --spare-devices=0      \
>        --parity=n2                             \
>        /dev/sd[abcdefgh]1
>
>>> # cat /proc/mdstat
>>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath]
>>> md1 : active raid10 sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
>>>        2118656 blocks 64K chunks 2 near-copies [8/8] [UUUUUUUU]
>                                      ^^^^^^^^^^^^^
> I will be testing far placement as well.
>
> I very much appreciate your interest and guidance. To clarify my
> goals, I am trying to demonstrate generalized RAID charac-
> teristics using an experimental workbench in various config-
> urations, tying the observed experimental data to expected
> values. I'd like to wring out obvious errors in my experimental
> technique.
>
> The initial motivation was a glaringly poor choice of RAID level
> for a performance-sensitive production system which I have to
> live with for years to come. The most unsettling aspect was that
> the selection process was stymied by the complexity of the
> choices and an abundance of disinformation. I want to address
> this pitfall by publishing an illustrated guide to performance,
> cost, and reliability up and down the storage stack, helping
> people to make reasoned choices in purchasing and configuring
> storage. Varying the RAID level and configuration are key (but
> not the only) parts of this work. I'm well along in the
> literature search, workbench setup, and toolchain. I'm expecting
> to put a year or two into the project and to open source
> everything.
>   
> Best regards,

I am excited to see the results of this project. Good luck! I'll be 
waiting patiently.

-- 
EJ Vincent
ej@ejane.org

