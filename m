From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: BUG:write data to degrade raid5
Date: Sat, 20 Mar 2010 11:50:47 -0400
Message-ID: <4BA4EED7.5070700@tmr.com>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jin zhencheng <zhenchengjin@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

jin zhencheng wrote:
> hi;
>
> i use kernel is 2.6.26.2
>
> what i do as follow:
>
> 1, I create a raid5:
> mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/sdd
> --metadata=1.0 --assume-clean
>
> 2, dd if=/dev/zero of=/dev/md5 bs=1M &
>
> write data to this raid5
>
> 3, mdadm --manage /dev/md5 -f /dev/sda
>
> 4 mdadm --manage  /dev/md5 -f /dev/sdb
>
> if i faild 2 disks ,then the OS kernel display OOP error and kernel down
>
>
> do somebody know why ?
>
> Is MD/RAID5 bug ?
>   

I would usually say that any kernel OOPS is a bug, but in this case, 
what are you running your Linux on, given that you just trashed the 
first four drives? While it's possible to run off of other drives, you 
have to make an effort to configure Linux to do so.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein
