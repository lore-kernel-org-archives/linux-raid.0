From: "Michael Guyver" <michael.guyver@gmail.com>
Subject: Re: Create software RAID from active partition
Date: Mon, 1 Sep 2008 15:28:37 +0100
Message-ID: <c8ce53500809010728g11e74ac2yc010d1d35e7466@mail.gmail.com>
References: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
	 <48BBEE7E.8050406@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48BBEE7E.8050406@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2008/9/1 David Greaves <david@dgreaves.com>:
> Michael Guyver wrote:
>> Hi there,
>>
>> I've got a question about creating a RAID-1 array on a remote server -
>> ie: if the operation fails, it's going to be very expensive. The
>> server has two 200 GB drives and during a hurried re-install of CentOS
>> 5.2 the creation of software RAID partitions was omitted. This means
>> that the array would include the currently active partition on which
>> the kernel is installed. So my first question is as to the feasibility
>> of this operation, and its safety: any comments?
>
> It looks to me like you have a system that is (almost) setup to use lvm
> mirroring, not md (raid) mirroring.
>
> Are you sure you want to swap to using md mirroring? Or do you want to restore
> the lvm mirror?
>

Well, I'm happy to take the path of least resistance but which would
also leave me with redundancy in case of a disk failure.

> So there are no issues mirroring the / fs.
> Simply make the /dev/mapper/VolGroup00-LogVol00 mirrored
> lvconvert -m or something.

I'll have a read of the lvconvert docs and

> Bear in mind that /boot and possibly the mbr won't be replicated so if a disk
> fails you may not lose your rootfs but you won't be booting either...

Thanks very much David, Steve and Allen for your helpful comments.
I'll do some reading about LVM mirroring and if it's as easy as it
appears may go down that route as it sounds slightly less hairy than
setting up software RAID on a server to which I have no physical
access. The costs of having someone at the data-centre restore the
server are prohibitive and I'm terrified of bricking the server (again
- long story ;).

Cheers

Michael
