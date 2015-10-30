From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: quickest way for complex operation?
Date: Fri, 30 Oct 2015 14:26:06 +0100
Message-ID: <20151030142606.Horde.D8WmIG47kX-kazg2Xb68-wV@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a working RAID6, consisting of seven disks.

I'd like to change all disks, because we suspect problems with the  
drive types / controller combination.

On top, I'd like to reduce the number of disks to six - the seventh  
disk was added during a operations test and the added space is not  
actually needed. (The upper layers still see the size of the RAID  
device as it was when only six disks were used).

The server chassis has 12 slots, ten of which are available to the  
RAID disks (seven disks, plus three empty slots).

As a first step, I inserted three of the new disks into the empty  
slots, added them as spares to the RAID set and ran mdraid --replace  
for three of the old disks.

The question is, how do I optimally continue once the first three  
disks are replaced and the according three old disks are removed. Can  
I both replace and resize in a single (or almost single) step?

I had hoped that something along the following might work:

- fail one of the remaining 4 old drives
- mark the other three old drives for replace
- reshape the RAID to 6 disks (which probably will start right away)
- insert the three new disks and add them as spares

which then *might* result (after the resync) in four old disks marked  
as faulty, leaving me with a six-disk RAID6 consisting of only the new  
disks.

Am I on the right track, or will I have to run this in individual  
steps (replace three more disks, then fail the remaining old disk,  
then reshape)?

The data is fully backed up and replicated live to another server, so  
the reduced resiliency to disk failure is less of a problem. But I'd  
like to do an online replacement, without taking days. The new disks  
are much faster than the old ones, too.

Thank you for any insight, ideas or comments you'd like to share.

Regards,
Jens



