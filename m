From: Jim Radford <jradford@npl.com>
Subject: Re: md_import_device returned -16 raid1
Date: Sat, 16 Jul 2005 16:32:05 -0700 (PDT)
Message-ID: <Pine.LNX.4.61.0507161630330.8523@hoss.npl.com>
References: <Pine.LNX.4.61.0507161534210.8523@hoss.npl.com>
 <17113.37737.512268.68189@cse.unsw.edu.au> <Pine.LNX.4.61.0507161611050.8523@hoss.npl.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0507161611050.8523@hoss.npl.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

lvm2 seems to be the cause, I removed all lv/vg/pv's and it started fine. 
My guess is I need to change something in the mandrake initscripts (order 
wise) to make sure lvm doesn't kick into gear until the raid has started.

Thanks for your thoughts!

Jim

On Sat, 16 Jul 2005, Jim Radford wrote:

> I'm not exactly sure what could be making it busy, I don't have it mounted, 
> and I can't seem to find anything in /proc that shows it is in use in another 
> way. I can't think of a way to check what might be causing it to think it is 
> in use. Even during boot before userspace it is giving the same error.
>
> Thanks for your assistance.
>
> [...]
> Bridge firewalling registered
>> Autodetecting RAID arrays.
>> autorun ...
>> ... autorun DONE.
>
> [...]
>
>> md0 stopped.
>> could not bd_claim hdc.
>> md_import_device returned -16
>> bind<hdb>
>> raid1 personality registered as nr 3
> raid1: raid set md0 active with 1 out of 2 mirrors
> kjournald starting.  Commit interval 5 seconds
>
> [...]
>
>
> /dev/hda1 on / type ext3 (rw)
> none on /proc type proc (rw)
> none on /sys type sysfs (rw)
> /dev/hda6 on /home type ext3 (rw)
>
> On Sun, 17 Jul 2005, Neil Brown wrote:
>
>> On Saturday July 16, jradford@npl.com wrote:
>>> Greetings all:
>>> 
>>> Having a bit of difficulty with raid1, I built the array lastnight with
>>> two new drives, and it built fine but when I rebooted I get the 
>>> following
>>> error when trying to start the array:
>>> 
>>> I'm running Mandrake 10.1 kernel 2.6.8.1-12mdk
>>> 
>>> [root@localhost jradford]# mdadm --version
>>> mdadm - v1.7.0 - 11 August 2004
>>> 
>>> [root@bengali jradford]# mdadm -A -s
>>> mdadm: failed to add /dev/hdc to /dev/md0: Device or resource busy
>> 
>> This is telling you that /dev/hdc is 'busy'.
>> Maybe a filesystem is mounted of it, or of a partition of it?
>> 
>> Could it already be in use?
>> 
>> NeilBrown
>> 
>
>

-- 
==========================================================================
Jim Radford <jradford@npl.com>
http://www.jimradford.com/
==========================================================================
