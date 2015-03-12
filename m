From: Paul Boven <boven@jive.nl>
Subject: Re: Raid 5: all devices marked spare, cannot assemble
Date: Thu, 12 Mar 2015 15:28:52 +0100
Message-ID: <5501A2A4.7060900@jive.nl>
References: <550184D4.8060104@jive.nl> <55019940.4030104@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55019940.4030104@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

Good morning and thanks for your quick reply.

On 03/12/2015 02:48 PM, Phil Turmel wrote:
>> I have a rather curious issue with one of our storage machines. The
>> machine has 36x 4TB disks (SuperMicro 847 chassis) which are divided
>> over 4 dual SAS-HBAs and the on-board SAS. These disks are in RAID5
>> configurations, 6 raids of 6 disks each. Recently the machine ran out of
>> memory (it has 32GB, and no swapspace as it boots from SATA-DOM) and the
>> last entries in the syslog are from the OOM-killer. The machine is
>> running Ubuntu 14.04.02 LTS, mdadm 3.2.5-5ubuntu4.1.
>
> {BTW, I think raid5 is *insane* for this size array.}

It's 6 raid5s, not a single big one. This is only a temporary holding 
space for data to be processed. In its original incarnation the machine 
had 36 distinct file-systems that we would read from in a software 
stripe, just to get enough IO performance. So this is a trade-off 
between IO-speed and lost capacity versus convenience in case a drive 
inevitably fails.

I guess you would recommend raid6? I would have liked a global hot 
spare, maybe 7 arrays of 5 disks, but then we lose 8 disks in total 
instead of the current 6.

> Wrong syntax.  It's already assembled.  Just try "mdadm --run /dev/md15"

Trying to 'run' md15 gives me the same errors as before:
md/raid:md15: not clean -- starting background reconstruction
md/raid:md15: device sdad1 operational as raid disk 0
md/raid:md15: device sdy1 operational as raid disk 3
md/raid:md15: device sdv1 operational as raid disk 4
md/raid:md15: device sdm1 operational as raid disk 2
md/raid:md15: device sdq1 operational as raid disk 1
md/raid:md15: allocated 0kB
md/raid:md15: cannot start dirty degraded array.
RAID conf printout:
--- level:5 rd:6 wd:5
  disk 0, o:1, dev:sdad1
  disk 1, o:1, dev:sdq1
  disk 2, o:1, dev:sdm1
  disk 3, o:1, dev:sdy1
  disk 4, o:1, dev:sdv1
md/raid:md15: failed to run raid set.
md: pers->run() failed ...

> If the simple --run doesn't work, stop the array and force assemble the
> good drives:
>
> mdadm --stop /dev/md15
> mdadm --assemble --force --verbose /dev/md15 /dev/sd{ad,q,m,y,v}1

That worked!
mdadm: looking for devices for /dev/md15
mdadm: /dev/sdad1 is identified as a member of /dev/md15, slot 0.
mdadm: /dev/sdq1 is identified as a member of /dev/md15, slot 1.
mdadm: /dev/sdm1 is identified as a member of /dev/md15, slot 2.
mdadm: /dev/sdy1 is identified as a member of /dev/md15, slot 3.
mdadm: /dev/sdv1 is identified as a member of /dev/md15, slot 4.
mdadm: Marking array /dev/md15 as 'clean'
mdadm: added /dev/sdq1 to /dev/md15 as 1
mdadm: added /dev/sdm1 to /dev/md15 as 2
mdadm: added /dev/sdy1 to /dev/md15 as 3
mdadm: added /dev/sdv1 to /dev/md15 as 4
mdadm: no uptodate device for slot 5 of /dev/md15
mdadm: added /dev/sdad1 to /dev/md15 as 0
mdadm: /dev/md15 has been started with 5 drives (out of 6).

I've checked that the filesystem is in good shape, and added /dev/sdd1 
back in, the array is now resyncing. 680 minutes to go, but there's a 
few tricks I can do to speed that up a bit.

> In other words, unclean shutdowns should have manual intervention,
> unless the array in question contains the root filesystem, in which case
> the risky "start_dirty_degraded" may be appropriate.  In that case, you
> probably would want your initramfs to have a special mdadm.conf,
> deferring assembly of bulk arrays to normal userspace.

I'm perfectly happy with doing the recovery in userspace, these drives 
are not critical for booting. Except that Ubuntu, Plymouth and a few 
other things conspire against booting a machine with any disk problems, 
but that's a different rant for a different place.

Thank you very much for your very helpful reply, things look a lot 
better now.

Regards, Paul Boven.
-- 
Paul Boven <boven@jive.nl> +31 (0)521-596547
Unix/Linux/Networking specialist
Joint Institute for VLBI in Europe - www.jive.nl
VLBI - It's a fringe science
