From: Mike Berger <lists@mike01.com>
Subject: Re: RAID 5 Recovery Help Needed
Date: Fri, 16 Jan 2009 15:09:00 -0600
Message-ID: <4970F76C.2040500@mike01.com>
References: <4970E18C.2000100@mike01.com> <4970F153.30106@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4970F153.30106@scalableinformatics.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Joe Landman wrote:
> eek ... a RAID5 on 3 drives?
I was planning on growing it as I needed more space and could afford
more drives (scary, I know).

> Did you do an
>
>     mdadm --detail --scan > /etc/mdadm.conf
>
> after this?
Unfortunately no.  The guide I followed neglected to mention that step.
> ... but did you update mdadm.conf as above?
> This generally requires an /etc/mdadm.conf (or similar
> /etc/mdadm/mdadm.conf)
> You can often (re)construct this file if you forget to create it with
> a little detective work ...
> mdadm --examine /dev/sdb1
> could be your friend.
>
> [...]
I did try putting the following into mdadm.conf manually after the
reboot (and before doing the create again):
DEVICES partitions
ARRAY /dev/md0 UUID=3128da32:c5e4ff31:b43fc0e6:226924cf

Then I tried to assemble it again (with scan), and still no luck. 
Unfortunately since the guide I used never mentioned the config file at
all, and seeing "DEVICE partitions" in it, I assumed it was fine.  I
never gave it more thought until the second create failed to improve things.


>
>> # fsck.ext4 -n /dev/md0
>>
>> I get:
>>
>> fsck.ext4: Superblock invalid, trying backup blocks...
>> fsck.ext4: Bad magic number in super-block while trying to open /dev/md0
>>
>> I've tried specifying the blocksize and specifying the superblock
>> manually using  the backup superblocks from when I ran mkfs.ext4, but
>> get the same result.  I haven't dared to run fsck without -n until I
>> hear from someone more knowledged.
>>
>> So, if anyone has any suggestions on how I can get md0 mounted or
>> recover my data it would be much appreciated.
>
> I am not completely sure, but I would bet that with the changes you
> have made, that this data may not be recoverable at this point.
>
> Before you do anything else, I would definitely suggest creating the
> mdadm.conf file properly as noted above.
>
> Joe
>
I've created an mdadm.conf file via 'mdadm --detail --scan', so assuming
that was the original problem with the raid not being assembled properly
before, that should be solved.  The problem now lies in getting my data
back if possible.  I don't plan to assemble the array again or try
anything else until I've given enough time for others wiser than I to
respond.

Thanks,
Mike
