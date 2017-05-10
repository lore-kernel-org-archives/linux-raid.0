From: Shaohua Li <shli@kernel.org>
Subject: Re: RAID creation resync behaviors
Date: Wed, 10 May 2017 10:30:29 -0700
Message-ID: <20170510173029.7cumdgokh6viebgq@kernel.org>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
 <87inlhpgzu.fsf@notabene.neil.brown.name>
 <20170504020452.kcmjgxnk7zsx7kdx@kernel.org>
 <1fca5ff4-358a-e0cf-d1a4-fc33ecdcbd62@gmail.com>
 <87o9v1n56m.fsf@notabene.neil.brown.name>
 <76407cb7-437b-142e-e74b-ddd56f3f4ddb@gmail.com>
 <yq1k25prbd4.fsf@oracle.com>
 <08ba08b3-0e8c-c064-6b35-9084545e2c22@gmail.com>
 <yq1bmr1rasn.fsf@oracle.com>
 <f73c7524-5d35-6104-11b1-2c658b43c68d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f73c7524-5d35-6104-11b1-2c658b43c68d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Tue, May 09, 2017 at 05:22:57PM -0400, Jes Sorensen wrote:
> On 05/09/2017 05:16 PM, Martin K. Petersen wrote:
> > 
> > Jes,
> > 
> > > This is fine within the kernel, however it is not overly useful for
> > > mdadm to determine which strategy to apply when syncing devices.
> > 
> > BLKZEROOUT
> > 
> 
> Trying to read the code, as this ioctl doesn't seem to be documented
> anywhere I can find.... it looks like this ioctl zeroes out a device.
> 
> It doesn't help me obtain the information I need to make a decision in mdadm
> as whether to overwrite all or compare+write when resyncing a RAID array.

The best way I can think is if we find the disks are SSD, trim the disks, and
read some random places. If all return 0, the guess is the SSD returns 0 after
trim, so do compare-write resync otherwise overwrite. Surely this needs extra
mdadm option to enable. We can only reliably detect a SSD, others lie.

Thanks,
Shaohua
