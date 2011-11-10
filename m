From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: [PATCH] kill-subarray: fix, IMSM cannot kill-subarray with
 unsupported metadata
Date: Thu, 10 Nov 2011 10:00:33 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D404EF31@IRSMSX101.ger.corp.intel.com>
References: <F9123E44003394499FDD2B17C60621D4043755@IRSMSX101.ger.corp.intel.com>
	<20111031113151.64f566b1@notabene.brown>
	<F9123E44003394499FDD2B17C60621D4043D80@IRSMSX101.ger.corp.intel.com>
	<20111101154807.0cf42aa5@notabene.brown>
	<F9123E44003394499FDD2B17C60621D4044D82@IRSMSX101.ger.corp.intel.com>
 <20111107123411.3751cd50@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111107123411.3751cd50@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,
I will be back with that subject with a patch (or an explanation ;)).
Marcin Labun

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, November 07, 2011 2:34 AM
> To: Labun, Marcin
> Cc: linux-raid@vger.kernel.org; Kwolek, Adam
> Subject: Re: [PATCH] kill-subarray: fix, IMSM cannot kill-subarray with
> unsupported metadata
> 
> On Thu, 3 Nov 2011 15:23:03 +0000 "Labun, Marcin"
> <Marcin.Labun@intel.com>
> wrote:
> 
> > Hi Neil,
> > This is OK.
> > However, reshape_container (called from Grow_continue_command)
> ignores info that is chosen by subarray string given by user.
> > Therefore, all container's arrays are possibly grown (including those
> > we want to block) So we need to patch Grow_continue, so it performs
> grow on the array that user requested, not all arrays that are in the
> reshape process.
> > Thanks,
> > Marcin
> >
> 
> I don't think I understand...
> 
> When continuing a grow the user shouldn't need to specify which
> subarray needs to be continued.  That information is in the metadata.
> So use just says "--grow --continue" and mdadm looks at the container
> to see which arrays are in the middle of a reshape and continues those.
> If one of them is such that the next array must be reshaped when this
> one completes, that should just happen automatically too.
> 
> ??
> 
> NeilBrown

