From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: resync starts over after each reboot (2.6.18.1)?
Date: Tue, 17 Oct 2006 11:28:22 +0200
Message-ID: <4534A236.4080907@wpkg.org>
References: <45349861.4010208@wpkg.org> <17716.41259.239292.413627@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17716.41259.239292.413627@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday October 17, mangoo@wpkg.org wrote:
>> I just set up a new Debian unstable box.
>> It's running 2.6.18.1 kernel.
>>
>> I created RAID-1 on two disks, with no data or filesystem on it.
>> As I'm still experimenting with the box, I reboot it quite frequently.
>>
>> I noticed that RAID-1 resync starts from the very beginning after each 
>> reboot. Is it normal?
> 
> No.
> Has the resync finished when you shut down?

No, it was still running.


> How do you shut down?

I simply type "reboot", so it should shutdown/reboot cleanly.


> Can you post the kernel logs from boot up to when the resync has
> started?

# dmesg|grep md

md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
md: md0 stopped.
md: bind<sdb1>
md: bind<sda1>
md: md0: raid array is not clean -- starting background reconstruction
raid1: raid set md0 active with 2 out of 2 mirrors
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for reconstruction.
md: using 128k window, over a total of 312568576 blocks.


(it has so many raid levels, as I'm still experimenting with it).


-- 
Tomasz Chmielewski
http://wpkg.org

