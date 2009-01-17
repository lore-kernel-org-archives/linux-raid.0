From: Mike Berger <lists@mike01.com>
Subject: Re: RAID 5 Recovery Help Needed
Date: Sat, 17 Jan 2009 12:51:07 -0600
Message-ID: <4972289B.30607@mike01.com>
References: <4970E18C.2000100@mike01.com> <4970F153.30106@scalableinformatics.com> <4970F76C.2040500@mike01.com> <49722439.3060103@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49722439.3060103@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
>
> Depending on your distribution, I would not be surprised to see your
> array assemble just fine with or without an ARRAY line, it seems some
> try harder than others and I just noticed that the system I use most
> has only "super minor" lines for the first three arrays and nothing
> for the rest, yet arrays 0..6 all come up at boot.
>
> However, the bad news is that many distributions don't do ext4 very
> well, and may mount an ext4 file system as ext3, resulting in damage
> which gets worse if you write to it. I would suggest starting the
> array, unmounted, running fsck.ext4 on the array, and seeing if it
> offers any hope of recovery. If so, after the fsck mount the array
> *read-only* and see what's there.
>
> Some distributions seem to need "ext4" on the boot command line to
> detect the file system type for mounting. Of course if it's in fstab
> it should work correctly, but I wouldn't bet the farm on it.
>
> -- 
> Bill Davidsen <davidsen@tmr.com>
>   "Woe unto the statesman who makes war without a reason that will still
>   be valid when the war is over..." Otto von Bismark 
>
>   
I have an ext4 partition on another drive working flawlessly, so I don't
think it is or was being mounted incorrectly as ext3.  I have a feeling
the ext4 boot option is needed for the root partition in the cases you
mention.

Thanks for the suggestions.  I've tried a dry run (-n) of fsck without
success, but put off doing a full fsck for fear of corrupting the data
were it to be recoverable.  I will try the full fsck before abandoning
all hope.

Mike
