From: <senthilkumar.muthukalai@wipro.com>
Subject: RE: RAID 5 rebuild fails with power interruption.
Date: Tue, 17 Nov 2009 12:00:46 +0530
Message-ID: <8338BD137FF1B64EB341218BD702985E02AB9233@BLR-EC-MBX03.wipro.com>
References: <8338BD137FF1B64EB341218BD702985E02AB8FCF@BLR-EC-MBX03.wipro.com><87y6m759o2.fsf@frosties.localdomain><8338BD137FF1B64EB341218BD702985E02AB90B8@BLR-EC-MBX03.wipro.com> <20091117094720.4c8736d7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20091117094720.4c8736d7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: goswin-v-b@web.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

We use metadata 1.2.

Thanks,
Senthil M

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Tuesday, November 17, 2009 4:17 AM
To: SenthilKumar Muthukalai (WT01 - Telecom Equipment)
Cc: goswin-v-b@web.de; linux-raid@vger.kernel.org
Subject: Re: RAID 5 rebuild fails with power interruption.

On Mon, 16 Nov 2009 16:00:38 +0530
<senthilkumar.muthukalai@wipro.com> wrote:

> We face this problem in our NAS product where we handle RAID5.
> In the below mentioned scenario, when RAID5 is rebuilding after
> adding a disk, we reset the power.
> Ideally when the system comes up, the RAID5 should have accepted the
> disk but not in our case.
> We get the 'kicking the non-fresh disk from array' message with the
> boot message.
> In our RAID init script we run 'mdadm -- Examine -- scan', followed by
> 'mdadm --assemble'.
> Could you pls help me to understand why this disk is being thrown out?

It is because the metadata being used (v0.90) does not have the ability
to record that a device is partially recoverred.   It can only record
that a device is either a full member of the array, or is not a member
of the array.  So until the recovery completes, the metadata only
records that the device is not a member of the array.  So when you
restart, you find that the device is not a member of the array.


> What could be the solution?

Use 1.x metadata.  e.g. add
   --metadata=1.1
to your --create command.
1.x metadata is able to record that a device is only partially
recovered.  So when the array is restarted the device will be included
and recovery will continue.

NeilBrown


> 
> -----Original Message-----
> From: goswin-v-b@web.de [mailto:goswin-v-b@web.de] 
> Sent: Monday, November 16, 2009 10:49 AM
> To: SenthilKumar Muthukalai (WT01 - Telecom Equipment)
> Cc: linux-raid@vger.kernel.org
> Subject: Re: RAID 5 rebuild fails with power interruption.
> 
> <senthilkumar.muthukalai@wipro.com> writes:
> 
> > Adding a subject line...
> >
> > -----Original Message-----
> > From: SenthilKumar Muthukalai (WT01 - Telecom Equipment) 
> > Sent: Monday, November 16, 2009 9:14 AM
> > To: linux-raid@vger.kernel.org
> > Subject: 
> >
> > Hi All,
> >
> > Could you pls help me out with the below problem?
> >
> > 1. Created a RAID5 with 3 disks.
> > 2. Initial rebuild done.
> > 3. Pulled out a disk from the array.
> > 4. The array got degraded.
> > 5. Added the disk back to the array with 'assemble' command.
> > 6. The disk was successfully added and the array started rebuilding
> > again.
> > 7. While rebuilding, reset the power to the NAS box.
> > 8. When the NAS box boot up, the RAID was in degraded with the added
> > disk thrown out.
> > 9. The boot messages say 'kicking out of the non-fresh disk from the
> > array'.
> >
> > We tried '--force' option with the 'assemble' command but no
> > success.
> >
> > Thanks,
> > Senthil M
> 
> mdadm --add /dev/md0 /dev/sdc1
> 
> But normaly it should just continue the resync.
> 
> MfG
>         Goswin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

