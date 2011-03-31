From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Network-based RAID6
Date: Wed, 30 Mar 2011 23:56:26 -0500
Message-ID: <4D94097A.3030909@hardwarefreak.com>
References: <20110330131157.49fd2521@natsu>	<AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>	<20110330144944.3c87185c@natsu>	<4D933188.30003@hardwarefreak.com> <20110330235052.3a803d35@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110330235052.3a803d35@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: CoolCold <coolthecold@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov put forth on 3/30/2011 12:50 PM:
> On Wed, 30 Mar 2011 08:35:04 -0500
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> If you want true block level replication over a network, look into DRBD.
>>  However, it is also limited to mirroring.
> 
> So I guess a viable and interesting solution could be an mdadm stripe over two
> or more DRBD mirrors, effectively providing RAID10. Although that's not quite
> what I am looking for (RAID5/6-levels of overhead and resilience).

The mdraid driver sits beneath DRBD.  What you suggest above is impossible.

-- 
Stan
