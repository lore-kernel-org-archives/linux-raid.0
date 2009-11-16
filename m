From: <senthilkumar.muthukalai@wipro.com>
Subject: RE: RAID 5 rebuild fails with power interruption.
Date: Mon, 16 Nov 2009 16:00:38 +0530
Message-ID: <8338BD137FF1B64EB341218BD702985E02AB90B8@BLR-EC-MBX03.wipro.com>
References: <8338BD137FF1B64EB341218BD702985E02AB8FCF@BLR-EC-MBX03.wipro.com> <87y6m759o2.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <87y6m759o2.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: goswin-v-b@web.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We face this problem in our NAS product where we handle RAID5.
In the below mentioned scenario, when RAID5 is rebuilding after adding a
disk, we reset the power.
Ideally when the system comes up, the RAID5 should have accepted the
disk but not in our case.
We get the 'kicking the non-fresh disk from array' message with the boot
message.
In our RAID init script we run 'mdadm -- Examine -- scan', followed by
'mdadm --assemble'.
Could you pls help me to understand why this disk is being thrown out?
What could be the solution?

-----Original Message-----
From: goswin-v-b@web.de [mailto:goswin-v-b@web.de] 
Sent: Monday, November 16, 2009 10:49 AM
To: SenthilKumar Muthukalai (WT01 - Telecom Equipment)
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID 5 rebuild fails with power interruption.

<senthilkumar.muthukalai@wipro.com> writes:

> Adding a subject line...
>
> -----Original Message-----
> From: SenthilKumar Muthukalai (WT01 - Telecom Equipment) 
> Sent: Monday, November 16, 2009 9:14 AM
> To: linux-raid@vger.kernel.org
> Subject: 
>
> Hi All,
>
> Could you pls help me out with the below problem?
>
> 1. Created a RAID5 with 3 disks.
> 2. Initial rebuild done.
> 3. Pulled out a disk from the array.
> 4. The array got degraded.
> 5. Added the disk back to the array with 'assemble' command.
> 6. The disk was successfully added and the array started rebuilding
> again.
> 7. While rebuilding, reset the power to the NAS box.
> 8. When the NAS box boot up, the RAID was in degraded with the added
> disk thrown out.
> 9. The boot messages say 'kicking out of the non-fresh disk from the
> array'.
>
> We tried '--force' option with the 'assemble' command but no success.
>
> Thanks,
> Senthil M

mdadm --add /dev/md0 /dev/sdc1

But normaly it should just continue the resync.

MfG
        Goswin
