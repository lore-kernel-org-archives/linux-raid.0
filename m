From: Mike Fowler <linux-raid@mlfowler.com>
Subject: RE: raid5 won't resync
Date: Tue, 31 Aug 2004 16:32:52 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41349A24.4000702@mlfowler.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had a similar problem on my box a couple of weeks ago. I have a 
dual-AMD 1.3GHz system, with two SIIG UltraATA 133 PCI IDE cards, eight 
hard drives, forming 2 RAID-5 arrays. Each array consists of four drives 
of one card. With just one raid active the machine would run fine, but 
with two it would lock on startup. In the end it turned out it was in 
interrupt race on the APIC chip, by disabling APIC (kernel parameter 
noapic) the machine was able to boot and resync the arrays. Might this 
help in your situation?

-- 
-Mike Fowler
"I could be a genius if I just put my mind to it, and I,
I could do anything, if only I could get 'round to it"



Jon Lewis wrote:

> On Tue, 31 Aug 2004, Guy wrote:
>
>  
>
>> I have read where someone else had a similar problem.
>> The slowdown was caused by a bad hard disk.
>>
>> Do a dd read test of each disk in the array.
>>
>> Example:
>> time dd if=/dev/sdj of=/dev/null bs=64k
>>   
>
>
> All of these finished at about the same time with no read errors 
> reported.
>
>  
>
>> Someone else has said:
>> Performance can be bad if the disk controller is sharing an interrupt 
>> with
>> another device.
>> It is ok for 2 of the same model cards to share 1 interrupt.
>>   
>
>
> Since it's an SMP system, IO APIC gives us lots of IRQs and there is no
> sharing.
>
>           CPU0       CPU1
>  0:     739040    1188881    IO-APIC-edge  timer
>  1:        173        178    IO-APIC-edge  keyboard
>  2:          0          0          XT-PIC  cascade
> 14:     355893     353513    IO-APIC-edge  ide0
> 15:    1963919    1944260    IO-APIC-edge  ide1
> 20:       7171       7690   IO-APIC-level  eth0
> 21:          2          3   IO-APIC-level  eth1
> 23:    1540742    1537849   IO-APIC-level  qlogicfc
> 27:    1540624    1539874   IO-APIC-level  qlogicfc
>
> Since the recovery had stopped making progress, I decided to fail the
> drive it had brought in as the spare with mdadm /dev/md2 -f /dev/sdf1.
> That worked as expected.  mdadm /dev/md2 -r /dev/sdf1 seems to have hung.
> It's in state D and I can't terminate it.  Trying to add a new spare,
> mdadm can't get a lock on /dev/md2 because the previous one is stuck.
>
> I suspect at this point, we're going to have to just reboot again.
>
> ----------------------------------------------------------------------
> Jon Lewis                   |  I route
> Senior Network Engineer     |  therefore you are
> Atlantic Net                |
> _________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

