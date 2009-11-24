From: Kasper Sandberg <postmaster@metanurb.dk>
Subject: Re: RAID 5 rebuild fails with power interruption.
Date: Tue, 24 Nov 2009 02:36:37 +0100
Message-ID: <1259026597.31633.129.camel@localhost>
References: <8338BD137FF1B64EB341218BD702985E02AB8FCF@BLR-EC-MBX03.wipro.com>
	 <87y6m759o2.fsf@frosties.localdomain>
	 <8338BD137FF1B64EB341218BD702985E02AB90B8@BLR-EC-MBX03.wipro.com>
	 <20091117094720.4c8736d7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091117094720.4c8736d7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: senthilkumar.muthukalai@wipro.com, goswin-v-b@web.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-11-17 at 09:47 +1100, Neil Brown wrote:
> On Mon, 16 Nov 2009 16:00:38 +0530
> <senthilkumar.muthukalai@wipro.com> wrote:
> 
> > We face this problem in our NAS product where we handle RAID5.
> > In the below mentioned scenario, when RAID5 is rebuilding after
> > adding a disk, we reset the power.
> > Ideally when the system comes up, the RAID5 should have accepted the
> > disk but not in our case.
> > We get the 'kicking the non-fresh disk from array' message with the
> > boot message.
> > In our RAID init script we run 'mdadm -- Examine -- scan', followed by
> > 'mdadm --assemble'.
> > Could you pls help me to understand why this disk is being thrown out?
> 
> It is because the metadata being used (v0.90) does not have the ability
> to record that a device is partially recoverred.   It can only record
> that a device is either a full member of the array, or is not a member
> of the array.  So until the recovery completes, the metadata only
> records that the device is not a member of the array.  So when you
> restart, you find that the device is not a member of the array.
> 
> 
> > What could be the solution?
> 
> Use 1.x metadata.  e.g. add
>    --metadata=1.1
> to your --create command.
> 1.x metadata is able to record that a device is only partially
> recovered.  So when the array is restarted the device will be included
> and recovery will continue.

Might it be possible to upgrade metadata without having to recreate the
array?

> 
> NeilBrown

<snip>

