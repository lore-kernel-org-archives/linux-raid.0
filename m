From: MRK <mrk@shiftmail.org>
Subject: Re: mdadm: failed devices become spares!
Date: Wed, 19 May 2010 00:25:16 +0200
Message-ID: <4BF313CC.9030401@shiftmail.org>
References: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com>
 <201005172010.36157.pierre@vigneras.name>
 <20100518113016.1981a08c@notabene.brown>
 <20100518120637.24d875c9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20100518120637.24d875c9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/18/2010 04:06 AM, Neil Brown wrote:
> However if --monitor gets to check the array between the above to events, it
> will first see that the working drive is now faulty, so it reports a failure,
> and then see that the faulty device isn't faulty any more and in fact isn't
> even there.  The "isn't event there" bit doesn't register and it treats it as
> 'SpareActive'.
>
> I should fix that.
>    

However in one case the two events are not detected in the same round:

Apr 12 20:10:02 phobos mdadm[3157]: Fail event detected on md device /dev/md2,
component device /dev/sdf1
Apr 12 20:11:02 phobos mdadm[3157]: SpareActive event detected on md device
/dev/md2, component device /dev/sdf1


1 minute passes between the two entries. I suppose that's the mdadm 
daemon polling time.

In the other case all the entries are at the same time

Apr 13 08:00:02 phobos mdadm[3157]: Fail event detected on md device /dev/md2,
component device /dev/sdd1
Apr 13 08:00:02 phobos mdadm[3157]: SpareActive event detected on md device
/dev/md2, component device /dev/sdd1
Apr 13 08:00:02 phobos last message repeated 7 times
[...many times that messages..]


...plus, in this second case the SpareActive triggers a lot of times 
within that same second (Pierre you cut it short, but are all the "many 
times that messages" all at the exact same time or they span a few seconds?)

It looks to me like some kind of usb failure where the USB connection or 
USB bridge momentarily fails then immediately gets re-detected and 
re-added to the system. But since there are no usb entries in dmesg, 
that would also be an issue of the usb driver. Could the problem also be 
a mixture with some unwise udev triggers of Debian, maybe somehow 
causing the auto-re-add of the drive to the RAID?

Pierre:
- can you post your mdadm.conf?
- USB is not good for RAID imho. Many times in my life I saw problems 
with USB/SATA bridges where the drive would get disconnected on high I/O 
activity and then reconnected after a few seconds. Anyway, readding it 
to the RAID shouldn't have happened. Also in my case there were "usb" 
entries in dmesg.
