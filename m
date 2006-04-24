From: Anssi Hannula <anssi.hannula@gmail.com>
Subject: Re: Recovery speed at 1MB/s/device, unable to change
Date: Mon, 24 Apr 2006 16:33:25 +0300
Message-ID: <444CD3A5.1000102@gmail.com>
References: <444BD3E7.4090601@gmail.com>	<444BF3AC.4090804@gmail.com> <17483.63636.745420.456281@cse.unsw.edu.au> <444C0481.2000408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444C0481.2000408@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anssi Hannula wrote:
> Neil Brown wrote:
> 
>>On Monday April 24, anssi.hannula@gmail.com wrote:
>>
>>
>>># mdadm --grow /dev/md_d1 --raid-devices=3 --backup-file backupfile
>>>mdadm: Need to backup 128K of critical section..
>>>mdadm: /dev/md_d1: Cannot get array details from sysfs
>>>
>>>Strace shows that it's trying to access
>>>"/sys/block/md_d4/md/component_size".
>>>
>>>Why is this?
>>
>>
>>Because I didn't test my code properly :-(
>>
>>Following patch should fix it.
>>
> 
> 
> It appears you missed another occurrence (patch attached).
> 
> However,
[...strange problems...]

The rest of my problems, including the slow speed of reconstruction were
solved by reboot and I'm unable to reproduce them.

Neil, thank you very much for the speedy replies :)

-- 
Anssi Hannula

