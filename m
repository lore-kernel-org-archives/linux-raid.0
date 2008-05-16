From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: questions about softraid limitations
Date: Fri, 16 May 2008 11:28:29 +0200
Message-ID: <022401c8b739$5262ba80$9300a8c0@dcccs>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs> <482AC2BB.5010602@dgreaves.com> <01be01c8b61a$6e616260$9300a8c0@dcccs> <482D479F.3040809@dgreaves.com>
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


----- Original Message ----- 
From: "David Greaves" <david@dgreaves.com>
To: "Janos Haar" <djani22@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Friday, May 16, 2008 10:36 AM
Subject: Re: questions about softraid limitations


> Janos Haar wrote:
>>> Firstly, are you aware that Linux SW raid will not understand disks
>>> written by hardware raid.
>> Yes, i know, but the linux raid is a great tool to try it, and if the
>> user know what he is doing, it is safe too. :-)
> OK - just checking :)

:)

>
>>> This will not allow md to write superblocks to the disks.
>>
>> I think exactly for this steps:
>>
>> dd if=/dev/zero of=suberblock.bin bs=64k count=1
>> losetup /dev/loop0 superblock.bin
>> blockdev --setro /dev/sda
>> mdadm --build -l linear /dev/md0 /dev/sda /dev/loop0
>>
>> The superblock area is writable.
>> And this is enough to try to assemble the array to do the recovery, but
>> this step is refused.
> Ah, I understand now.
> I think you need -n2 to tell mdadm to use 2 devices.

Sorry i forget. :-)
I wrote this on the fly, not a real example....

>
>>>> Its OK, but what about building a readonly raid 5 array for recovery
>>>> usage only? :-)
>>> That's fine. If they are md raid disks. Yours aren't yet since you
>>> haven't
>>> written the superblocks.
>>
>> I only want to help for some people to get back the data.
>> I only need to build, not to create.
>
> I think this would be really hard if they are not md arrays since the 
> on-disk
> layout is likely to be different. Not something I know how to do.
>
> Typically the first step in recovery is to duplicate the disks using 
> ddrescue
> and work on copies of the duplicates where you can overwrite things.
> If you have had a hardware failure on the drive then even mounting 
> readonly can
> make things worse. (If the mb/controller failed then fair enough - but in 
> that
> case it's not a 'recovery', just a simple, 'no-risk(tm)' migration... ?)

Yes, i can agree.
At this time, i working in my data recovery company, and some times need to 
recover the broken hw raid arrays too.
(with md arrays, we have no problem at all. :-) )

In your rows, we talking about 2 cases:

a, disk hw problem (only bad sectors, the completely failed disk is in 'b' 
case)
Yes, the ddrescue is the best way, to do the recovery, but:
The ddrescue is too agressive with default -e 0 setting!
This can be easily fail down the drive! (dependig the reason of the bad 
sectors)
And with the images, we have another problem!
The 0x00 holes.
The hw or md have no deal about where we need recover from parity and where 
we have real zero blocks....
Overall this is why data recovery companys learning and developing more and 
more.... :-)

b, the disk is fine, but the hw raid card is failed, or the array have a 
logical problem eg 2 disk in raid 5 is out of sync.
In this case the duplication is only waste of time.
The recovery safely in readonly mode.

Often the problem with the arrays is the time.
The servers using the array, and all the down time is expensive.
In my case, the recovery is already successfully done, but yes, i need to 
copy all the x TB data, to make only a readonly probe.... :-(

>
> Tell us more about the failed system:
> * hardware or md raid5  (if hw then you'll need a *lot* of info about 
> on-disk
> layout and I personally have no clue how to help - sorry)

The card was an adaptech scsi raid card, and 5 disk in raid 5.
Electrical problem (black out) made the 2 disk out of sync, and the card let 
me no chance to repair, or safely rebuild the array, only erase it....
But with md, ist done. :-)

I need no help at this time, i just want to share my ideas, to helping 
upgrading/developing md, and helping for people....

Thanks,

Janos

>
> If md:
> * kernel of original system and new system
> * new mdadm version
> * what kind of failure occured
> * any dmesg data you have
> * can you ddrescue the drives and do mdadm --examine /dev/sd<partition> 
> for each
> component.
>
> Cheers
> David
> PS Aplogies if I'm stating things that are obvious to you :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

