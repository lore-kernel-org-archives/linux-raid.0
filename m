From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Slow(?) raid5 to raid6 reshape speed
Date: Tue, 16 Feb 2010 12:34:48 -0500
Message-ID: <4B7AD738.6080503@tmr.com>
References: <ee1fb9c4204eafc9daffb4341d0de646@rw23.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ee1fb9c4204eafc9daffb4341d0de646@rw23.de>
Sender: linux-raid-owner@vger.kernel.org
To: Michael <michael@rw23.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael wrote:
> Hello,
>
> iam reshaping my 4-drive raid5 to a 5-drive raid6, but the speed is a
> little slow.
>
> md2 : active raid6 sdc3[0] sdg3[4] sdf3[3] sda3[2] sdd3[1]
>       2898182016 blocks super 0.91 level 6, 64k chunk, algorithm 18 [5/4]
> [UUUU_]
>       [======>..............]  reshape = 34.2% (330530816/966060672)
> finish=2897.5min speed=3655K/sec
>
> i know it is a expensive process, but my system near-to-idle, so there may
> be something wrong.
> with top, i can see there is no noticable cpu load caused by the md2_raid6
> process or any other.
> with iotop, i can see mdadm reading and writing a little data once a
> secound, but not continuous.
>
> i think the kernel's raid io is not visible at iotop or iam wrong?
>
> i have moved the --backup-file from my usb drive to a internal ide hard
> drive and gained 800k/sec more speed.
> ~3000-4000k/sec are not so bad that the reshaping takes forever, but could
> be faster, right?
>
> i have tried playing around with sync_speed_min and sync_speed_max without
> any result.
> setting the stripe_cache to 8192 or something did not show a real
> performance gain.
>
>   
You can go larger than that, double it or try 32k. I have heard reports 
of evil at 64k, I wouldn't go there other than with test data.

> is my speed bad, good, normal? any ideas how to "tune" it a bit?
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

