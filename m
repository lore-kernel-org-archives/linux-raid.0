From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/4] mdadm: bad block support for external metadata -
 initialization
Date: Wed, 26 Oct 2016 12:23:16 -0700
Message-ID: <20161026192316.wntpx6jcyay756j7@kernel.org>
References: <1476968626-19233-1-git-send-email-tomasz.majchrzak@intel.com>
 <20161020140220.GB17867@www5.open-std.org>
 <20161020142611.GA23120@proton.igk.intel.com>
 <wrfj4m3zkn1s.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <wrfj4m3zkn1s.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, keld@keldix.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 26, 2016 at 02:00:47PM -0400, Jes Sorensen wrote:
> Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> > I cannot see how badblocks program is related to this patch. It is a generic
> > code for bad blocks support in IMSM metadata. It introduces 64-bit value for
> > sector address, the same size as in kernel. All it does is syncing kernel bad
> > block list with raid metadata.
> >
> > Tomek
> 
> I was waiting for this response, but you cut me off the CC list so
> missed it.
> 
> In this case I'll go ahead and apply these patches to mdadm.

Thomasz,

So your original kernel patch to support bad block for external metadata writes
'-blocked' to state. We agreed it's not required later and the applied kernel
patches don't support that interface. Don't you need change of the mdadm
patches?

Thanks,
Shaohua
