From: Jeff Woods <kazrak+kernel@cesmail.net>
Subject: Re: RAID1 VS RAID5
Date: Mon, 27 Oct 2003 02:16:40 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.2.1.1.0.20031027015844.03a85e68@no.incoming.mail>
References: <200310261716.17030.maarten@vbvb.nl>
 <1067179519.1222.107.camel@cala>
 <200310261716.17030.maarten@vbvb.nl> <200310270927.32751.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310270927.32751.dusty@strike.wu-wien.ac.at>
References: <200310261716.17030.maarten@vbvb.nl>
 <1067179519.1222.107.camel@cala>
 <200310261716.17030.maarten@vbvb.nl>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Cc: maarten van den Berg <maarten@vbvb.nl>, Mario Giammarco <mgiammarco@virgilio.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 10/27/2003 09:27 AM +0100, Hermann Himmelbauer wrote:
>It seems you're missing something: Interleaving means here, reading one 
>part of the data from one disk and another part from the other disk, not 
>reading the same data from both.
>
>When reading a file from the RAID1, you could e.g. read the first block 
>from the first disk, the second from the second disk, the third from the 
>first disk and so on.
>
>This would *theoretically* double the read speed - like with RAID0.
>
>Practically this speed doubling would not occur as you have to add the 
>seek times when reading files, but I assume with TCQ and things like that 
>there could be some tricks to optimize the read behavior.
>
>Anyway - it seems no RAID1 implementation - be it hardware or software 
>RAID1 - seems to make use of this read performance increase.

Disc I/O performance is significantly more complicated than you seem to 
perceive it.  Disc drive performance (in stand-alone, JBOD and RAID 
configurations) depends on many factors such as spindle speed, number of 
sectors per track and cylinder (which varies substantially between inner 
and outer cylinders) and other things.  However, serial reads are generally 
limited by the rotation speed (measured in sectors passing the head(s) per 
second) and seek times of the portion of the drive being accessed.

As performance benchmarks that test inner versus outer cylinders generally 
show, the drives are much faster at both random seeks and sustained 
transfer rates on the "larger" outer cylinders.  That's because more data 
is flying under the heads on each rotation and head seeks are needed less 
often (especially for sequential reads and/or writes!).

Alternating I/Os between two spindles on a RAID1 pair won't (in general) 
speed up the transfer rate.  Worse, it will needlessly monopolize both 
spindles when only one provides the same performance.  Leaving the other 
spindle available to seek to another part of the drive and provide double 
the bandwidth has major advantages in a multiprocessing environment 
(including typical Linux, Unix and Windows environments... even single user 
"desktop" workstations).  It sounds to me like the current algorithm used 
likely provides near-optimal performance for RAID1 configuration.

OTOH, you have access to the source code if you really want to try it 
another way.  But I strongly urge you to actually benchmark any changes you 
make to prove that you've made an improvement, especially before submitting 
it as a patch to the current code.

--
Jeff Woods <kazrak+kernel@cesmail.net> 


