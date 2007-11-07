From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: doesm mdadm try to use fastest HDD ?
Date: Wed, 07 Nov 2007 10:10:36 +0100
Message-ID: <87k5ouju9f.fsf@informatik.uni-tuebingen.de>
References: <20071102125205.52c2d115@absurd> <472B21BF.4060201@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472B21BF.4060201@tmr.com> (Bill Davidsen's message of "Fri, 02
	Nov 2007 09:10:23 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen <davidsen@tmr.com> writes:

> Janek Kozicki wrote:
>> Hello,
>>
>> My three HHDs have following speeds:
>>
>>   hda - speed 70 MB/sec
>>   hdc - speed 27 MB/sec
>>   sda - speed 60 MB/sec
>>
>> They create a raid1 /dev/md0 and raid5 /dev/md1 arrays. I wanted to
>> ask if mdadm is trying to pick the fastest HDD during operation?
>>
>> Maybe I can "tell" which HDD is preferred?
>>
>
> If you are doing raid-1 between hdc and some faster drive, you could
> try using write-mostly and see go that works for you. For raid-5, it's
> faster to read the data off the slow drive than reconstruct it with
> multiple reads to multiple othjer faster drives.

Won't it naturally balance reads according to the disk speeds if there
are enough streams reading? I know raid1 prefers a disk that is
already near the location it wants. But won't it pick the first idle
one if there is no disk near the location? And the faster disk will be
idle more often.

MfG
        Goswin
