From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: 3TB drives failure rate
Date: Mon, 29 Oct 2012 09:26:54 -0400
Message-ID: <508E841E.5060704@meetinghouse.net>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com> <508D65CF.1080904@gmail.com> <508DADC3.4080104@shiftmail.org> <508DB08D.20002@meetinghouse.net> <508DC6E9.8070001@shiftmail.org> <508DC922.7040400@meetinghouse.net> <20121029102919.1134a797@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121029102919.1134a797@natsu>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov wrote:
> On Sun, 28 Oct 2012 20:09:06 -0400
> Miles Fidelman <mfidelman@meetinghouse.net> wrote:
>
>> Two separate issues.
>> The comments about "dropping out of raid" had to do with drives that are
>> slow to come out of sleep mode - causing hiccups when the RAID
>> hardware/software simply doesn't see the drive, and drops it.
> There are no drives in good working order that would come out of sleep mode SO
> slowly, that the Linux kernel ATA subsystem would even give up trying and
> return an I/O error from it (and it's only after that point, when this begins
> to become mdraid's concern).

I was just pointing out that the "dropping out of raid" sub-thread was 
started by a comment about sleep mode causing hiccups, which is a 
separate issue from that of RAID arrays getting f*&ked by long read 
delays from failing consumer drives.

I run servers, I wouldn't be crazy enough to use drives that go to sleep 
(not that they'd have the opportunity).

-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra

