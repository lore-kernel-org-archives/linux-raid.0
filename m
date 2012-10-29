From: David Brown <david.brown@hesbynett.no>
Subject: Re: 3TB drives failure rate
Date: Mon, 29 Oct 2012 08:54:14 +0100
Message-ID: <508E3626.8080404@hesbynett.no>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com> <508D65CF.1080904@gmail.com> <508DADC3.4080104@shiftmail.org> <508DB08D.20002@meetinghouse.net> <508DC6E9.8070001@shiftmail.org> <508DC922.7040400@meetinghouse.net> <20121029102919.1134a797@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121029102919.1134a797@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Miles Fidelman <mfidelman@meetinghouse.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/10/2012 05:29, Roman Mamedov wrote:
> On Sun, 28 Oct 2012 20:09:06 -0400
> Miles Fidelman <mfidelman@meetinghouse.net> wrote:
>
>> Two separate issues.
>
>> The comments about "dropping out of raid" had to do with drives that are
>> slow to come out of sleep mode - causing hiccups when the RAID
>> hardware/software simply doesn't see the drive, and drops it.
>
> There are no drives in good working order that would come out of sleep mode SO
> slowly, that the Linux kernel ATA subsystem would even give up trying and
> return an I/O error from it (and it's only after that point, when this begins
> to become mdraid's concern).
>
> I have yet to see even any first sign of "SATA frozen" due to drive sleep
> mode, let alone to imagine this last through all the port resets and speed
> step-downs the SATA driver will attempt.
>
> So the "sleep" issue is not relevant with Linux software RAID, and if you're
> still concerned that it might be, you can just reconfigure your drives so they
> don't enter that sleep mode.
>

The same applies to the long retry times of "desktop" drives - Linux 
software raid has no problem with them.  Some (perhaps "many" or "all" - 
I don't have the experience with hardware raid cards to say) hardware 
raid cards see long read retries as a timeout on the disk, and will drop 
the whole disk from the array.

Linux md raid will wait for the data to come in, and use it if it is 
valid.  If the disk returns an error, the md layer will re-create the 
data from the other disks, then re-write the bad block.  The disk will 
then re-locate the bad block to one of its spare blocks, and everything 
should be fine.  (If the write also fails, the drive gets kicked out.)

So with software raid, there are no problems using desktop drives of any 
sort in your array (assuming, of course, you don't have physical issues 
such as heat generation, vibration, support contracts, etc., that might 
otherwise make you prefer "raid" or "enterprise" drives).

