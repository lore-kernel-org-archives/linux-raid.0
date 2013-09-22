From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5+spare volume gone - mdadm sees RAID1 only?
Date: Sun, 22 Sep 2013 17:45:54 -0400
Message-ID: <523F6512.2050007@turmel.org>
References: <CAFjqtwhDa03Yi2kaWAVCVpYPxPmF3omwAw2KW4cmKfQerXFwug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFjqtwhDa03Yi2kaWAVCVpYPxPmF3omwAw2KW4cmKfQerXFwug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: P Agenbag <internet@mweb.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/22/2013 02:02 PM, P Agenbag wrote:
> Hi List
> 
> I have a D-Link DNS345 NAS which I configured as RAID5 + spare with 4x
> 500GB Seagate SATA drives.
> 
> I suspect a power surge caused the NAS to suddenly lose the volume.
> 
> All 4 drives checked out OK when doing a SMART test on the NAS itself.
> I proceeded to build all 4 drives into a CentOS server, but was unable
> to mount the RAID5 - error is always "not enough drives".
> 
> I followed some advise in archives, and did some mdadm -- examines,
> and echo them below - what I don't understand is why the --examine
> picks them up as RAID1.
> 
> Is there anything I can do to re-build this array?

The "mdadm --examine" info you gave is clearly for the NAS boot
volume--it is only 1/2 GB--and would be expected to be raid1.

Please take a closer look at your partition tables....

Share them here if you can't get further, and include "mdadm --examine"
from all other partitions that have raid superblocks.

Phil

