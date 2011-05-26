From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 7 of 9] MD:  new sb type
Date: Thu, 26 May 2011 10:34:58 +1000
Message-ID: <20110526103458.7fcde1bc@notabene.brown>
References: <201105240307.p4O374rN029659@f14.redhat.com>
	<20110525141645.24e8fe29@notabene.brown>
	<2AE351EE-5C38-4C1B-B6A6-C9ABF5718E48@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2AE351EE-5C38-4C1B-B6A6-C9ABF5718E48@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 25 May 2011 09:40:06 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> 
> On May 24, 2011, at 11:16 PM, NeilBrown wrote:
> 
> >> +	__le32 level;
> >> +	__le32 new_level;
> >> +
> >> +	__le32 layout;
> >> +	__le32 new_layout;
> >> +
> >> +	__le32 stripe_sectors;
> >> +	__le32 new_stripe_sectors;
> >> +
> >> +	__le32 num_devices;    /* Number of devs in RAID, Max = 64 */
> >> +	__le32 new_num_devices;
> > 
> > Presumably the dm table knows all this info as well and it is just here for
> > error checking - yes?
> 
> Error checking, yes... but a little bit more.
> 
> If we keep this information in the superblock (instead of LVM metadata), then the act of reshaping is done like this:
> 1) initial RAID device created - LVM (or some other DM utilizing manager) records necessary info to re-instantiate this device.
> 2) A reshape (if LVM, 'lvconvert') is issued.  LVM will record only the information about the new RAID layout.  It will submit only this information to device-mapper (and on to MD) for further activations.
> The information in the superblock is then used to say, "ok, I see you passed in RAID6 information, but I was RAID5, so I must convert (or continue to convert)."  Any new conversions while a conversion is in process are denied.  So, it is relevant only so far as reshaping is concerned.

OK, that makes sense.
You could argue that the 'new' info is redundant because that is what is
provided in the dm table, but it probably make sense to keep it.

Thanks,

NeilBrown


> 
> If we keep this information in the LVM metadata, the process becomes far more messy:
> 1) initial RAID device created
> 2) A reshape is issued.  This time LVM must record all the information for both states - requiring additions to the LVM metadata layout, which in turn require new code for parsing and assembling this information as well as the code for turning it into something device-mapper can understand.
> 3) The reshape issued to device-mapper would require a new constructor, destructor, and status functions in dm-raid.c specifically for reshape scenarios.
> 4) An event would have to be raised when the reshape is complete in order to inform LVM to complete the reshape action (i.e. remove the intermediate metadata and write the final metadata describing the end product). This requires new plug-ins for the 'dmeventd' daemon, and of course, new LVM code to be able to convert from the hybrid device to the final device.  And what happens if the daemon is hung, segfaulting, or just not there?  The final change-over doesn't complete.  If this is followed by a machine reboot, LVM will have no way of knowing whether the process was never begun or whether it was finished - reshape_offset doesn't help in this case.
> This is a truly horrible way to go...
> 
> I've cleaned up the other items you mentioned.  Of course, depending on which way we go regarding analyze_sbs, the bulk of these super functions may be pushed into dm-raid.c.
> 
>  brassow

