From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: Re: [git patch] 2.6.x libata fix more information DEBUG INFO !!!
Date: Fri, 13 Jan 2006 21:06:10 +0000
Message-ID: <43C81642.3030309@projecthugo.co.uk>
References: <20060109171104.GA25793@havoc.gtf.org> <43C4DB86.7030603@projecthugo.co.uk> <43C628FE.9020303@projecthugo.co.uk> <43C64182.1000702@projecthugo.co.uk> <43C78E77.4010603@projecthugo.co.uk> <E1ExSVL-0002Tx-Vk@highlab.com> <43C804AA.1050303@projecthugo.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C804AA.1050303@projecthugo.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Darcy <kernel-lists@projecthugo.co.uk>
Cc: Sebastian Kuzminsky <seb@highlab.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Darcy wrote:

> Sebastian Kuzminsky wrote:
>
>> Matt Darcy <kernel-lists@projecthugo.co.uk> wrote:
>>  
>>
>>> Its almost as if there is an "IO leak" which is the only way I can 
>>> think of to describe it.the card / system performaces quite well as 
>>> individual disks, but as soon as its entered into a raid 5 
>>> configuration using the any number of disks the creation of the 
>>> array appears to be fine until around %20-%30 through the assembly, 
>>> the speed of the arrays creations plummits and the machine hangs.
>>>   
>>
>>
>> You have 7x250G disks in Raid-5, so that's 6x250G or 1.5T total space.
>> In the beginning of raid recovery, when the system is good, you're
>> getting 12M/s.  It slows then dies after 25% to 40% of completion.
>>
>> 6x250G is 1536000M, at 12M/s that's about 35 hours.  You tested the
>> disks individually (without Raid) for ~12 hours, which is about 34%
>> of 35 hours.  So it's possible you'd see the the same slowdown & hang
>> if you tested the individual disks longer.
>>
>> You're having these problems on a Marvell controller with 2.6.15 and the
>> in-kernel sata_mv driver, right?  I've got a very similar system with
>> unexplained hard hangs too.  On my system the individual disks seem to
>> work fine, Raid-6 of the disks seems work fine, LVM of the disks seems
>> to work fine, but LVM of a Raid-6 of the disks hangs.
>>
>> One wierd thing I've discovered is that if I enable all the kernel
>> debugging options, the system is perfectly stable, and all the debug
>> tests report no warnings or errors to the logs.  Seems like a race
>> condition somewhere, I'm suspecting in the interaction of Raid-6 and
>> LVM, but it could be anywhere I suppose.  I've attached the .config of
>> the production (non-debug) kernel that hangs, and the diff to the debug
>> kernel that works.
>>
>>  
>>
>
>
> Just to clarify a few things,
>
> using the 2.6.15 kernel I can use and assemble the raid 5 array 
> without a problem, however using it lvm2 causes it to hang exactly as 
> you have mentioned before.
>
> When I first started working this problem through I started using some 
> of he mm patches with the 2.6.15-rc's which made a good difference, in 
> that I could build and use the array and even with lvm2 for a period 
> of time, however there was a few quirky bugs with it, in that it 
> couldn't maintain the arrays stability, on certain occasions, if I 
> rebooted the box, most of the disks would be marked as unsuable and 
> the array would refuse to start until it was rebuilt, to futher 
> progress this I started using the libata git branch which again made 
> things a "little" better, until the last 2 git versions where I have 
> this problem with the raid array not being able to build.
>
> from the results I have,  have a gut feeling that this is a driver 
> issue, simpley due to the different results i get with the different 
> kernels.
>
> I've been given some good thoughts today (last mail in from Mark Haln 
> has some good suggestions), so all I can do is run the tests Mark 
> suggested and report back the results to try to progress this forward, 
> although Marks tests seem to point to hardware issues, such as heat, 
> vibration etc I still believe this lies at a software driver level, 
> but its worth running the tests to see what additional data I can get, 
> and to prove/disprove Marks suggestoins.
>
> I shall report back later
>
> thanks,
>

> Matt

Ok,

reverting back to 2.6.15-rc5-mm3 which was my "good" kernel

I started to rebuild me 3+1 spare raid 5 array (smaller test array) and 
it hung on about %50 through
however - from this kernel I got debug results. Bellow (I'll snip them 
in future mails)

I'm going to try the same test again with the latest git kernel to see 
what happens.


Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041321f>] mv_channel_reset+0xff/0x120

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041327a>] mv_stop_and_reset+0x3a/0x60

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c04128ab>] mv_host_intr+0x13b/0x180

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041298d>] mv_interrupt+0x9d/0x130

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c014080d>] handle_IRQ_event+0x3d/0x70

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c01408b6>] __do_IRQ+0x76/0x100

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c0105089>] do_IRQ+0x19/0x30

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c01033ee>] common_interrupt+0x1a/0x20

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041316c>] mv_channel_reset+0x4c/0x120

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c0512aeb>] schedule+0x31b/0x6a0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c03fb2b0>] scsi_error_handler+0x0/0xb0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041327a>] mv_stop_and_reset+0x3a/0x60

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041374f>] mv_eng_timeout+0x6f/0xb0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c040b4b7>] ata_scsi_error+0x17/0x30

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c03fb33b>] scsi_error_handler+0x8b/0xb0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c01325e6>] kthread+0xb6/0xc0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c0132530>] kthread+0x0/0xc0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c0101389>] kernel_thread_helper+0x5/0xc

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041365e>] __mv_phy_reset+0x3be/0x420

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041321f>] mv_channel_reset+0xff/0x120

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041328a>] mv_stop_and_reset+0x4a/0x60

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c04128ab>] mv_host_intr+0x13b/0x180

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041298d>] mv_interrupt+0x9d/0x130

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c014080d>] handle_IRQ_event+0x3d/0x70

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c01408b6>] __do_IRQ+0x76/0x100

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c0105089>] do_IRQ+0x19/0x30

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c01033ee>] common_interrupt+0x1a/0x20

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041316c>] mv_channel_reset+0x4c/0x120

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c0512aeb>] schedule+0x31b/0x6a0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c03fb2b0>] scsi_error_handler+0x0/0xb0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041327a>] mv_stop_and_reset+0x3a/0x60

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c041374f>] mv_eng_timeout+0x6f/0xb0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c040b4b7>] ata_scsi_error+0x17/0x30

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c03fb33b>] scsi_error_handler+0x8b/0xb0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c01325e6>] kthread+0xb6/0xc0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c0132530>] kthread+0x0/0xc0

Message from syslogd@berger at Fri Jan 13 20:59:05 2006 ...
berger kernel:  [<c0101389>] kernel_thread_helper+0x5/0xc


