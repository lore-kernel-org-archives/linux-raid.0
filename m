From: Luca Berra <bluca@comedia.it>
Subject: Re: Raid-10 mount at startup always has problem
Date: Sat, 27 Oct 2007 09:57:06 +0200
Message-ID: <20071027075706.GB12053@percy.comedia.it>
References: <46D49F1A.7030409@tmr.com> <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com> <1193294406.10336.76.camel@firewall.xsintricity.com> <20071026091513.GB32550@percy.comedia.it> <20071026165340.GA30268@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071026165340.GA30268@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 26, 2007 at 06:53:40PM +0200, Gabor Gombas wrote:
>On Fri, Oct 26, 2007 at 11:15:13AM +0200, Luca Berra wrote:
>
>> on a pc maybe, but that is 20 years old design.
>> partition table design is limited because it is still based on C/H/S,
>> which do not exist anymore.
>
>The MS-DOS format is not the only possible partition table layout. Other
>formats such as GPT do not have such limitations.
>
>> Put a partition table on a big storage, say a DMX, and enjoy a 20%
>> performance decrease.
>
>I assume your "big storage" uses some kind of RAID. Are your partitions
>stripe-aligned? (Btw. that has nothing to do with partitions, LVM can
>also suffer if PEs are not aligned).
mine are, unfortunately the default is to start them at 32256 bytes into
the device.

>>> Oh, and let's not go into what can happen if you're talking about a dual
>>> boot machine and what Windows might do to the disk if it doesn't think
>>> the disk space is already spoken for by a linux partition.
>> Why the hell should the existance of windows limit the possibility of
>> linux working properly.
what i am saying is that a dual boot machine is not the only scenario we
have.

>> On the opposite, i once inserted an mmc memory card, which had been
>> initialized on my mobile phone, into the mmc slot of my laptop, and was
>> faced with a load of error about mmcblk0 having an invalid partition
>> table. Obviously it had none, it was a plain fat filesystem.
>> Is the solution partitioning it? I don't think the phone would
>> agree.
>
>Well, it said it could not find a valid partition change. That was the
>truth. Why is it a problem if the kernel states a fact?
it is random. reformatting it made the kernel message go away.
i wonder if by chance something would decide it is a valid partition
table....

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
