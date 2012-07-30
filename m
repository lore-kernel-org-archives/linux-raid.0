From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Sun, 29 Jul 2012 22:07:54 -0300
Message-ID: <CABYL=TrK+PWbqVsXPQZdz9EiFLgnTuuF0EuEN0Eo-CHqz+FX1g@mail.gmail.com>
References: <20120726080150.GA21457@kernel.org>
	<5012BB6D.8070104@computer.org>
	<CANejiEXvVq8eQVkSAXbexE72d-PhBMOs-T7MT1rfEyfSqjhocQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANejiEXvVq8eQVkSAXbexE72d-PhBMOs-T7MT1rfEyfSqjhocQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jan Ceuleers <jan.ceuleers@computer.org>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

this could be good to SD cards too... not only to resync

2012/7/29 Shaohua Li <shli@kernel.org>:
> 2012/7/28 Jan Ceuleers <jan.ceuleers@computer.org>:
>> On 07/26/2012 10:01 AM, Shaohua Li wrote:
>> ...
>>> To reduce write, we always compare raid disk data and only write mismatch part.
>>> This means sync will have extra IO read and memory compare. So this scheme is
>>> very bad for hard disk raid and sometimes SSD raid too if mismatch part is
>>> majority. But sometimes this can be very helpful to reduce write, in that case,
>>> since sync is rare operation, the extra IO/CPU usage is worthy paying. People
>>> who want to use the feature should understand the risk first. So this ability
>>> is off by default, a sysfs entry can be used to enable it.
>>
>> For clarity: the risk you are talking about is that the sync will result in more reads, as well as more CPU cycles spent comparing data. Is that right? I.e. there is no risk whatsoever to data integrity?
>>
>> Can you comment on the magnitude of this risk? For example, if this functionality is inadvertently applied to hard disks, and assuming that the components reside on separate spindles (which is a safe bet), wouldn't those reads happen in parallel thereby not significantly contributing to the slowdown? In other words: the principal component of the slowdown is the in-memory data comparison?
>>
>> But isn't there then an upside resulting from the avoidance of some writes where data is found to already match?
>
> data integrity should be guaranteed. To do sync, without the patch, we
> read disk1, write disk 2. With it,
> we read disk1/disk2, memory compare, if match, skip write, otherwise,
> write disk2. So if data match,
> the tradeoff is a memory compare (and write is replaced with read). If
> not match, the tradeoff is
> memory compare and extra read.
>
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
