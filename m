From: "Janos Haar" <djani22@netcenter.hu>
Subject: Re: questions about softraid limitations
Date: Thu, 15 May 2008 01:29:57 +0200
Message-ID: <01be01c8b61a$6e616260$9300a8c0@dcccs>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs> <482AC2BB.5010602@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello David,

----- Original Message ----- 
From: "David Greaves" <david@dgreaves.com>
To: "Janos Haar" <djani22@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, May 14, 2008 12:45 PM
Subject: Re: questions about softraid limitations


> Janos Haar wrote:
>> Hello list, Neil,
>
> Hi Janos
>
>> I have worked on a faulty hw raid card data recovery some days before.
>> The project is already successfully done, but i run into some 
>> limitations.
>
> Firstly, are you aware that Linux SW raid will not understand disks 
> written by
> hardware raid.

Yes, i know, but the linux raid is a great tool to try it, and if the user 
know what he is doing, it is safe too. :-)

>
>> Than try to build an "old fashion" linear arrays from each disks + 64k
>> another blockdevice. (for store the superblock)
>> But the mdadm refused to _build_ the array, because the source scsi
>> drive is jumpered to readonly. Why? :-)
> This will not allow md to write superblocks to the disks.

I think exactly for this steps:

dd if=/dev/zero of=suberblock.bin bs=64k count=1
losetup /dev/loop0 superblock.bin
blockdev --setro /dev/sda
mdadm --build -l linear /dev/md0 /dev/sda /dev/loop0

The superblock area is writable.
And this is enough to try to assemble the array to do the recovery, but this 
step is refused.

>
>>
>> I try to build the array with --readonly option, but the mdadm still
>> dont understand what i want. (yes, i know, rtfm...)
> This will start the array in readonly mode - you've not created an array 
> yet
> because you haven't written any superblocks...

Yes, i only want to build, not to create.

>
>
>> Its OK, but what about building a readonly raid 5 array for recovery
>> usage only? :-)
> That's fine. If they are md raid disks. Yours aren't yet since you haven't
> written the superblocks.

I only want to help for some people to get back the data.
I only need to build, not to create.

Thanks,

Janos Haar


>
>
> David
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

