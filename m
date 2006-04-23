From: Anssi Hannula <anssi.hannula@gmail.com>
Subject: Re: Recovery speed at 1MB/s/device, unable to change
Date: Mon, 24 Apr 2006 01:48:39 +0300
Message-ID: <444C0447.4040200@gmail.com>
References: <444BD3E7.4090601@gmail.com>	<444BF3AC.4090804@gmail.com> <17483.63636.745420.456281@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17483.63636.745420.456281@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(sorry, prev post missed the list)

Neil Brown wrote:
> On Monday April 24, anssi.hannula@gmail.com wrote:
> 
>># mdadm --grow /dev/md_d1 --raid-devices=3 --backup-file backupfile
>>mdadm: Need to backup 128K of critical section..
>>mdadm: /dev/md_d1: Cannot get array details from sysfs
>>
>>Strace shows that it's trying to access
>>"/sys/block/md_d4/md/component_size".
>>
>>Why is this?
> 
> 
> Because I didn't test my code properly :-(
> 
> Following patch should fix it.

Okay, will test.

> Re: the recovery speed problem:  I would try dding from one drive to
> the other and see what sort of speed you get then:
>   dd if=/dev/sda of=/dev/sdb bs=1024k count=1000
> or something like that.


# export LANGUAGE=C; export LANG=C; export LC_ALL=C; date; dd
if=/dev/sda skip=20000 of=/dev/sdb bs=1024k count=1000; date
Mon Apr 24 01:14:48 EEST 2006
1000+0 records in
1000+0 records out
Mon Apr 24 01:15:42 EEST 2006

So the speed is about 20MB/s.

-- 
Anssi Hannula


