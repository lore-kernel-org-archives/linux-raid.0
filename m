From: Mathias Mueller <raidfail@gmx.de>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 10 Nov 2015 22:33:33 +0100
Message-ID: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil,

>> This both combinations
> 
> Well, I gave you *four* combinations for order, and two suggestions for
> chunk size.  Eight combinations to try.

Sorry, this two words were just the beginning of a sentence, which I 
didn't finish an forgot to remove :)

I tried 16 combinations at all (eight with --data-offset=1024 and eight 
with --data-offset=2048), the following four combinations gave the 
"/dev/md0 has unsupported feature(s)" message occurs:

--data-offset=1024 --chunk 64: sde sdd sdb sdc
--data-offset=1024 --chunk 512: sde sdd sdb sdc
--data-offset=1024 --chunk 64: sde sdb sdd sdc
--data-offset=1024 --chunk 512: sde sdb sdd sdc

the other four combinations with --data-offset=1024 and all eight 
combinations with --data-offset=2048 gave

fsck.ext2: Superblock invalid, trying backup superblocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0


>> /dev/md0 has unsupported feature(s): FEATURE_C16 FEATURE_C17 
>> FEATURE_C18
>> FEATURE_C19 FEATURE_C21 FEATURE_C22 FEATURE_C23 FEATURE_C25 
>> FEATURE_C27
>> FEATURE_C28 FEATURE_I29 FEATURE_R29
>> e2fsck: Get a newer version of e2fsck!
> 
> None of the feature bits are documented to exist.  The choice of first
> drive must be wrong.

oh that's good to know

>> Also mdadm --examine on on of the drives tells "Data offset: 2048
>> Sectors" when mdadm --create --data-offset 1024 is used. Is this 
>> normal?
>> It's confusing me (using --data-offset 2048 on creation gives "Data
>> offset: 2048 Sectors").
> 
> mdadm must be enforcing a minimum offset.

is it possible that the data-offset differs from device to device?

Thanks

Mathias
