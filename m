From: Tyler <pml@dtbb.net>
Subject: Re: Good, recent FS comparison?
Date: Thu, 15 Sep 2005 20:10:55 -0700
Message-ID: <432A37BF.7060305@dtbb.net>
References: <6d5bedd8050915131148b8108a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd8050915131148b8108a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: ewan.grantham@gmail.com
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You'd be best off trying some tests of your own, using files of the size 
and quantity you expect to use on a regular basis.  I would consider 
ext3, xfs, and reiser3/4... and run some tests with them.  We've had 
really good luck using XFS on large raids, I personally had a bad 
experience with reiserfs 3, it lost data on a USB based drive, as if it 
were never even there, even after trying the recovery tools.

Regards,
Tyler.

Ewan Grantham wrote:

>I've just setup a nice, 6-disk, USB-2 300 Gig/disk array, and was
>prepared to follow my normal pattern of installing ext3 as the
>filesystem. However, I saw the interview with Hans Reiser about
>ReiserFS4, and am now wondering if reiser has really improved enough
>to use it, or if ext3 is still the way to go?
>
>Any thoughts?
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>


-- 
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.344 / Virus Database: 267.11.0/103 - Release Date: 9/15/2005

