From: "Eric D. Mudama" <edmudama@bounceswoosh.org>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 02:05:22 -0700
Message-ID: <20110209090522.GA8632@bounceswoosh.org>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
 <4D517F4F.4060003@gmail.com>
 <4D5245DF.4020401@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5245DF.4020401@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: maurice <mhilarius@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb  9 at  1:44, Stan Hoeppner wrote:
>maurice put forth on 2/8/2011 11:37 AM:
>> On 2/7/2011 1:07 PM, Roberto Spadim wrote:
>>> hi guys, could md send TRIM command to ssd? using ext4 discart mount option?
>>> if i mix ssd and hd, could this TRIM be rewrite to non TRIM compatible disks?
>>>
>> I have read that using md with SSDs is not a great idea:
>> Form the Fedora 14 documentation:
>
>Using any RAID level but pure striping with SSDs is a bad idea, for the exact
>reason in that documentation:  excessive writes.

If I mirror two SSDs, and write 1 unit of data to the mirror, each
element of the mirror should see 1 unit of write.  How does this
perform excessive writes, compared to the same workload applied to a
single SSD?

I agree that in aggregate we've now done 2 units worth of writes,
however, in a mirror case, we're protecting against both whole-device
failure and single-sector failure modes, so hardly seems like a bad
idea in all applications.


-- 
Eric D. Mudama
edmudama@bounceswoosh.org

