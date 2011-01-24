From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA questions
 for HW owners/users
Date: Sun, 23 Jan 2011 19:52:57 -0600
Message-ID: <4D3CDB79.4000100@hardwarefreak.com>
References: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com> <4D39D8B5.1090901@hardwarefreak.com> <AANLkTin2UZJc8yP6DGf2fgcDemQHznch5rGozmnL+V_u@mail.gmail.com> <4D3B0009.6020006@hardwarefreak.com> <AANLkTimqNjq6H5X5dPnM8Aw5W3NWtdY7ptGqQJ3ogJmO@mail.gmail.com> <4D3B7B2C.5040003@hardwarefreak.com> <4D3C64CB.2080002@harddata.com> <4D3C9C94.8090607@hardwarefreak.com> <4D3CB72E.3050000@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D3CB72E.3050000@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Maurice Hilarius put forth on 1/23/2011 5:18 PM:
> On 1/23/2011 2:24 PM, Stan Hoeppner wrote:
>> ..
>>> Chenbro backplanes do not support 6Gb SAS/SATA.
>> Considering no single (mech) drive can push 600 MB/s, let alone 300 MB/s, is
>> this really an issue?

> Yes.
> I have seen it first hand.
> If you connect 6GB drives and interfaces to it, you see a lot of errors.
> One has to be careful to set all devices to 3GB, assuming the devices have
> jumpers or other means to do so.

Which chassis model was this?

>>    Mech drives aren't even going to be surpassing 300 MB/s
>> in the foreseeable future.
>>
> Perhaps, but their buffers do, and if one uses expanders it is useful

The _real world_ application performance difference between SATA II and SATA III
mech drive interfaces is something on the order of 1%.  With SSDs a little more
as some of them can actually push data faster than 3 Gb/s.

Upstream of an expander the additional b/w is useful, not downstream.

-- 
Stan
