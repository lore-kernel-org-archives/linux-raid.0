From: "Eric D. Mudama" <edmudama@bounceswoosh.org>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 10:17:44 -0700
Message-ID: <20110209171744.GC8632@bounceswoosh.org>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
 <4D517F4F.4060003@gmail.com>
 <4D5245DF.4020401@hardwarefreak.com>
 <iiu4rc$9ju$1@dough.gmane.org>
 <AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
 <AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
 <20110209161916.GB8632@bounceswoosh.org>
 <AANLkTimQ+B2sXt0AZiUYW2QrWqpUvt7PLnkVCOwZqx0k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimQ+B2sXt0AZiUYW2QrWqpUvt7PLnkVCOwZqx0k@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Scott E. Armitage" <launchpad@scott.armitage.name>
Cc: "Eric D. Mudama" <edmudama@bounceswoosh.org>, Roberto Spadim <roberto@spadim.com.br>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb  9 at 11:28, Scott E. Armitage wrote:
>Who sends this command? If md can assume that determinate mode is
>always set, then RAID 1 at least would remain consistent. For RAID 5,
>consistency of the parity information depends on the determinate
>pattern used and the number of disks. If you used determinate
>all-zero, then parity information would always be consistent, but this
>is probably not preferable since every TRIM command would incur an
>extra write for each bit in each page of the block.

True, and there are several solutions.  Maybe track space used via
some mechanism, such that when you trim you're only trimming the
entire stripe width so no parity is required for the trimmed regions.
Or, trust the drive's wear leveling and endurance rating, combined
with SMART data, to indicate when you need to replace the device
preemptive to eventual failure.

It's not an unsolvable issue.  If the RAID5 used distributed parity,
you could expect wear leveling to wear all the devices evenly, since
on average, the # of writes to all devices will be the same.  Only a
RAID4 setup would see a lopsided amount of writes to a single device.

--eric

-- 
Eric D. Mudama
edmudama@bounceswoosh.org

