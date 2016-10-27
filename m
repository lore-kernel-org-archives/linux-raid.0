From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH 1/4] mdadm: bad block support for external metadata -
 initialization
Date: Thu, 27 Oct 2016 11:26:03 +0200
Message-ID: <20161027092603.GA13413@proton.igk.intel.com>
References: <1476968626-19233-1-git-send-email-tomasz.majchrzak@intel.com>
 <20161020140220.GB17867@www5.open-std.org>
 <20161020142611.GA23120@proton.igk.intel.com>
 <wrfj4m3zkn1s.fsf@redhat.com>
 <20161026192316.wntpx6jcyay756j7@kernel.org>
 <wrfjvawekhn0.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <wrfjvawekhn0.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 26, 2016 at 03:57:39PM -0400, Jes Sorensen wrote:
> Shaohua Li <shli@kernel.org> writes:
> > On Wed, Oct 26, 2016 at 02:00:47PM -0400, Jes Sorensen wrote:
> >> Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> >> > I cannot see how badblocks program is related to this patch. It is a generic
> >> > code for bad blocks support in IMSM metadata. It introduces 64-bit value for
> >> > sector address, the same size as in kernel. All it does is syncing
> >> > kernel bad
> >> > block list with raid metadata.
> >> >
> >> > Tomek
> >> 
> >> I was waiting for this response, but you cut me off the CC list so
> >> missed it.
> >> 
> >> In this case I'll go ahead and apply these patches to mdadm.
> >
> > Thomasz,
> >
> > So your original kernel patch to support bad block for external metadata writes
> > '-blocked' to state. We agreed it's not required later and the applied kernel
> > patches don't support that interface. Don't you need change of the mdadm
> > patches?
> 
> Well I'll wait until this is resolved then :)

I have explained the process in detail in the other email. I haven't done any
change to '-blocked' action. It is still requested by mdmon as disk is in
blocked state when bad block is awaiting for confirmation. However my accepted
patch stopped reporting disk as faulty if there are unacknowledged bad blocks.
I have realized that disk should be shown as faulty only for unrecoverable
state. Unacknowledged bad block can still be handled so this state is not
adequate. My first mdadm patch set ignored this flag if all bad blocks have
been successfully acknowledged. It was not fully correct as it would not work
if bad block and unrecoverable error happen at the same time.

I have resent the patches that don't ignore faulty state after acknowledging
bad blocks.

Tomek
