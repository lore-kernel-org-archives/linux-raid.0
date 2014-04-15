From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Force mdadm to not prompt the user
Date: Tue, 15 Apr 2014 08:41:44 +0200
Message-ID: <534CD4A8.6030205@gmail.com>
References: <534BFFB8.2030203@gmail.com> <20140415084830.1cbf299c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140415084830.1cbf299c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/15/2014 12:48 AM, NeilBrown wrote:
> On Mon, 14 Apr 2014 17:33:12 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
> 
>> Hello,
>>
>> I'm using mdadm in script which setup a system automtically.
>>
>> When creating a RAID array, I'd like mdadm to not prompt the user.
>>
>> Currently I get:
>>
>> # mdadm --create array1 --force --metadata=1.0 --level=raid1
>> --raid-devices=3 /dev/vdb1 /dev/vdc1 /dev/vdd1
>> mdadm: /dev/vdb1 appears to be part of a raid array:
>>        level=raid0 devices=0 ctime=Thu Jan  1 01:00:00 1970
>> mdadm: metadata will over-write last partition on /dev/vdb1.
>> Continue creating array?
>>
>> I thought that using --force would do the trick, but it didn't.
>>
>> I'm using mdadm - v3.3 - 3rd September 2013
>>
>> Is there any other way to achieve that ?
> 
> run
>    man mdadm
> 
> search for "prompt".... doesn't find anything.
> search for "ask".  Ahh, there is the answer.
> 

ah, sorry I missed it.

In the meantime I tried the --zero-superblock in order to clean the
metadata from /dev/vdb1:

# mdadm --create array1 --force --metadata=1.0 --level=raid1
--raid-devices=3 /dev/vdb1 /dev/vdc1 /dev/vdd1
mdadm: /dev/vdb1 appears to be part of a raid array:
       level=raid0 devices=0 ctime=Thu Jan  1 01:00:00 1970
mdadm: metadata will over-write last partition on /dev/vdb1.
Continue creating array? n
mdadm: create aborted.

# mdadm --zero-superblock /dev/vdb1
mdadm: Unrecognised md component device - /dev/vdb1

# mdadm --zero-superblock --force /dev/vdb1
mdadm: Unrecognised md component device - /dev/vdb1

# mdadm --create array1 --force --metadata=1.0 --level=raid1
--raid-devices=3 /dev/vdb1 /dev/vdc1 /dev/vdd1
mdadm: /dev/vdb1 appears to be part of a raid array:
       level=raid0 devices=0 ctime=Thu Jan  1 01:00:00 1970
mdadm: metadata will over-write last partition on /dev/vdb1.
Continue creating array? n

mdadm doesn't tell me which metadata it sees but I tried the different
ones and got the same result.

What am I missing ?

Thanks.

