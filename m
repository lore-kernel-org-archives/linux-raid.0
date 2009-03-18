From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 18 Mar 2009 10:50:08 +0100
Message-ID: <87vdq7w46n.fsf@frosties.localdomain>
References: <87ljr4hsk9.fsf@frosties.localdomain>
	<62620.69.0.24.162.1237347686.squirrel@huskymailweb.uconn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62620.69.0.24.162.1237347686.squirrel@huskymailweb.uconn.edu>
	(david geib's message of "Tue, 17 Mar 2009 23:41:26 -0400 (EDT)")
Sender: linux-raid-owner@vger.kernel.org
To: david.geib@huskymail.uconn.edu
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

david.geib@huskymail.uconn.edu writes:

>> Now for the raid6 case. With only 1 data disk and 2 parity disks all 3
>> disks should end up with identical data on them. In effect this should
>> be a 3 disk raid1, a cpu intensive one. Take an existing raid1 with 2
>> or 3 disks, stop the raid, create a new raid6 ovver it with
>> --assume-clean, start the raid. After that one can add more disks and
>> --grow -n 4/5/6/.. the raid6 to a sensible size. Again without going
>> into degraded mode.
>
> If this is the only case where it would be useful, wouldn't it be better
> to add an option to mdadm --grow specifying a new raid level, if
> different? That way you could take your /dev/md9 raid1 and do:
>
> mdadm --add /dev/md9 /dev/sdc1
> mdadm --grow -n 3 /dev/md9 --level=5
>
> or
>
> mdadm --add /dev/md9 /dev/sdc1 /dev/sdd1
> mdadm --grow -n 4 /dev/md9 --level=6
>
> or convert a raid5 to raid6 in like fashion, for that matter.

That would do 2 things in one, convert the raid level and grow the
stripes.

On the other hand, if 3 disk raid6 where allowed, then this could be
broken down into 2 simple operations for the userspace: 1) change raid
level without restriping, 2) restripe, which we already know how to
do.

To me it just seems easier to teach the kernel to online reload a raid
device with a different raid mode without any changes, covering
conversion of 1<->4, 1<->5 and 1<->6 in both directions, than to
combine the 2 steps.

That would only leave conversion from 4/5 <-> 6 as complicated case.


And hey, maybe I am crazy and do want a 3 disk raid6 next to my 2 disk
raid5, my 1 disk raid10, my 1 disk raid1 and my 1 disk raid0. :)
The limitation in the kernel just seems arbitrary, that is unless one
of the raid algorithms would break down with just 3 disks.

MfG
        Goswin

