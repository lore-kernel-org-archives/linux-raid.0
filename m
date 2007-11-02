From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: doesm mdadm try to use fastest HDD ?
Date: Fri, 02 Nov 2007 09:10:23 -0400
Message-ID: <472B21BF.4060201@tmr.com>
References: <20071102125205.52c2d115@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071102125205.52c2d115@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Hello,
>
> My three HHDs have following speeds:
>
>   hda - speed 70 MB/sec
>   hdc - speed 27 MB/sec
>   sda - speed 60 MB/sec
>
> They create a raid1 /dev/md0 and raid5 /dev/md1 arrays. I wanted to
> ask if mdadm is trying to pick the fastest HDD during operation?
>
> Maybe I can "tell" which HDD is preferred?
>   

If you are doing raid-1 between hdc and some faster drive, you could try 
using write-mostly and see go that works for you. For raid-5, it's 
faster to read the data off the slow drive than reconstruct it with 
multiple reads to multiple othjer faster drives.
> This came to my mind when I saw this:
>
>   # mdadm --query --detail /dev/md1 | grep Prefer
>  
>   Preferred Minor : 1
>
> And also in the manual:
>
>   -W, --write-mostly [...] "can be useful if mirroring over a slow link."
>
>
> many thanks for all your help!
>   
I have two thoughts on this:
1 - if performance is critical, replace the slow drive
2 - for most things you do, I would expect seek to be more important 
than transfer rate

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

