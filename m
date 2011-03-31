From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Network-based RAID6
Date: Thu, 31 Mar 2011 00:35:49 -0500
Message-ID: <4D9412B5.30203@hardwarefreak.com>
References: <20110330131157.49fd2521@natsu>	<AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>	<20110330144944.3c87185c@natsu>	<4D933188.30003@hardwarefreak.com>	<20110330235052.3a803d35@natsu>	<4D94097A.3030909@hardwarefreak.com> <20110331111613.06079a0a@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110331111613.06079a0a@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: CoolCold <coolthecold@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov put forth on 3/31/2011 12:16 AM:
> On Wed, 30 Mar 2011 23:56:26 -0500
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> Roman Mamedov put forth on 3/30/2011 12:50 PM:
>>> So I guess a viable and interesting solution could be an mdadm stripe over
>>> two or more DRBD mirrors, effectively providing RAID10. Although that's
>>> not quite what I am looking for (RAID5/6-levels of overhead and
>>> resilience).
>>
>> The mdraid driver sits beneath DRBD.  What you suggest above is impossible.
> 
> I thought DRBD presents just a regular kernel-level block device in /dev, and
> seeing how one can create mdraid out of just any kind of block device,
> including those provided by AoE, iSCSI, LVM, dmcrypt or even 'loop', are you
> really sure this matters here? 

Do it and report your results.

-- 
Stan
