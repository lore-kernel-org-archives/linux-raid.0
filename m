From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: Resurrecting a Dirty RAID-5
Date: Mon, 13 Jul 2015 17:15:29 +1000
Message-ID: <55A36591.8040004@websitemanagers.com.au>
References: <OFC233BA12.DDED55A2-ON85257E7C.00420655-85257E7C.0043331F@jt-sw.com> <559D2374.7040208@turmel.org> <OF71F1F6CD.C562AA57-ON85257E7D.000FAD79-85257E7D.0010311B@jt-sw.com> <alpine.DEB.2.02.1507120756020.11810@uplift.swm.pp.se> <OF4E023A92.1624DC91-ON85257E80.0051B769-85257E80.005287C5@jt-sw.com> <55A2EB25.10607@websitemanagers.com.au> <55A35B4B.9020706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55A35B4B.9020706@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/07/15 16:31, Can Jeuleers wrote:
> On 13/07/15 00:33, Adam Goryachev wrote:
>> Also, for your raid1, never have a hot spare, just do this:
>> mdadm /dev/mdX --grow --raid-devices=3
>> Then you will always have all your data replicated on all three drives,
>> so again, no hot spare required.
> Never say never, as there are valid use cases for having hot spares in a
> RAID1 set.
>
> My own use case is that I want to be reasonably assured that my spare
> won't fail at around the same time as the active disks (due to having
> the same age and having been subjected to exactly the same workload).

Yes, this is true too... though with physical HDD, I would expect there 
are enough differences to mean that they will fail at different times, 
even SSD's should have enough variance.

Of course, the other option is to purchase the drives at different times 
(eg, one month apart) so they are also from different batches, as well 
as have a month or two difference in how they are used.

Of course, if both drives in the RAID1 fail at the exact same moment, 
how is a hot spare better than a three drive raid1? Wouldn't the chance 
of three drives failing at the same critical moment be less than the 
chance of two drives failing at the same time (or one drive to fail, and 
then the second to fail during the increased load of a resync)?

I really have no idea about the actual statistical numbers/chances, but 
sounds like a valid question to me...

PS, of course, you should never say never, so I do still agree with you, 
someone, somewhere might have a reason to do it differently. However, if 
they really do, then they should know better than me.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
P: +61 2 8304 0000                    adam@websitemanagers.com.au
F: +61 2 8304 0001                     www.websitemanagers.com.au

