From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC 1/2]raid1: only write mismatch sectors in sync
Date: Mon, 30 Jul 2012 08:39:38 +0800
Message-ID: <CANejiEXvVq8eQVkSAXbexE72d-PhBMOs-T7MT1rfEyfSqjhocQ@mail.gmail.com>
References: <20120726080150.GA21457@kernel.org>
	<5012BB6D.8070104@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5012BB6D.8070104@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

2012/7/28 Jan Ceuleers <jan.ceuleers@computer.org>:
> On 07/26/2012 10:01 AM, Shaohua Li wrote:
> ...
>> To reduce write, we always compare raid disk data and only write mismatch part.
>> This means sync will have extra IO read and memory compare. So this scheme is
>> very bad for hard disk raid and sometimes SSD raid too if mismatch part is
>> majority. But sometimes this can be very helpful to reduce write, in that case,
>> since sync is rare operation, the extra IO/CPU usage is worthy paying. People
>> who want to use the feature should understand the risk first. So this ability
>> is off by default, a sysfs entry can be used to enable it.
>
> For clarity: the risk you are talking about is that the sync will result in more reads, as well as more CPU cycles spent comparing data. Is that right? I.e. there is no risk whatsoever to data integrity?
>
> Can you comment on the magnitude of this risk? For example, if this functionality is inadvertently applied to hard disks, and assuming that the components reside on separate spindles (which is a safe bet), wouldn't those reads happen in parallel thereby not significantly contributing to the slowdown? In other words: the principal component of the slowdown is the in-memory data comparison?
>
> But isn't there then an upside resulting from the avoidance of some writes where data is found to already match?

data integrity should be guaranteed. To do sync, without the patch, we
read disk1, write disk 2. With it,
we read disk1/disk2, memory compare, if match, skip write, otherwise,
write disk2. So if data match,
the tradeoff is a memory compare (and write is replaced with read). If
not match, the tradeoff is
memory compare and extra read.

Thanks,
Shaohua
