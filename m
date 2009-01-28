From: Vladimir Ivashchenko <hazard@francoudi.com>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Wed, 28 Jan 2009 23:37:45 +0200
Message-ID: <20090128213745.GA7923@francoudi.com>
References: <1233174633.7008.34.camel@hazard2.francoudi.com> <4980CF36.60106@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4980CF36.60106@scalableinformatics.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <landman@scalableinformatics.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't have a problem upgrading to a more recent kernel. I'll do it and try again.

           CPU0       CPU1       CPU2       CPU3       
  0:      35796     219508    1367509  714846322    IO-APIC-edge  timer
  1:          0          0          0          2    IO-APIC-edge  i8042
  8:          0          0          1          0    IO-APIC-edge  rtc
  9:          0          0          0          1   IO-APIC-level  acpi
 12:          0          0          0          4    IO-APIC-edge  i8042
 50:          0    6685568          2        400   IO-APIC-level  eth0
169:         43       4556         32        101   IO-APIC-level  ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
177:   26565935      88022      65347      67440   IO-APIC-level  ohci_hcd:usb4
185:      26477   12697949      31539      31684   IO-APIC-level  ohci_hcd:usb5
193:   18125889   55786346   52018220   19481451   IO-APIC-level  sata_mv
201:   41459172   34509549   20492998   45295899   IO-APIC-level  sata_mv
209:   33309776   34688917   26929934   44091250   IO-APIC-level  sata_mv
217:   30980862   21002267   29723861   21791804   IO-APIC-level  sata_mv
225:   40838685   22136210   38218071   21081955   IO-APIC-level  sata_mv
233:   30862641   22239226   33000041   31993705   IO-APIC-level  sata_mv
NMI:          0          0          0          0 
LOC:  716498535  716498534  716498533  716498532 
ERR:          1
MIS:          0


On Wed, Jan 28, 2009 at 04:33:42PM -0500, Joe Landman wrote:

>> Any stability assurances or workarounds are highly appreciated. :)
>> Jan 28 21:31:32 SunSTG kernel: BUG: soft lockup - CPU#0 stuck for 10s!
>
> [...]
>
>> Jan 28 21:31:32 SunSTG kernel:  [<f8d63562>] compute_parity6+0x21c/0x28a
>> [raid456]
>> Jan 28 21:31:32 SunSTG kernel:  [<f8d6452e>] handle_stripe+0xc8b/0x215e
>> [raid456]
>> Jan 28 21:31:32 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
>> Jan 28 21:31:32 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
>> Jan 28 21:31:32 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
>> Jan 28 21:31:32 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
>> Jan 28 21:31:32 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
>> [raid456]
>> Jan 28 21:31:33 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
>> [raid456]
>> Jan 28 21:31:33 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
>> Jan 28 21:31:33 SunSTG kernel:  [<c0436347>] autoremove_wake_function
>> +0x0/0x2d
>> Jan 28 21:31:33 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
>> Jan 28 21:31:33 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
>> Jan 28 21:31:33 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
>> Jan 28 21:31:33 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
>> +0x7/0x10
>
> Are you able to update the kernel to something more modern, or are you 
> required to keep the kernel at the 2.6.18 level?  Out of curiousity, could 
> you post the output of
>
> 	cat /proc/interrupts
>
>
> -- 
> Joseph Landman, Ph.D
> Founder and CEO
> Scalable Informatics LLC,
> email: landman@scalableinformatics.com
> web  : http://www.scalableinformatics.com
>        http://jackrabbit.scalableinformatics.com
> phone: +1 734 786 8423 x121
> fax  : +1 866 888 3112
> cell : +1 734 612 4615

-- 
Best Regards
Vladimir Ivashchenko
Chief Technology Officer
PrimeTel, Cyprus - www.prime-tel.com
