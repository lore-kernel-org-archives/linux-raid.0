From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/9] MD: add a new disk role to present cache device
Date: Wed, 5 Aug 2015 10:25:20 +1000
Message-ID: <20150805102520.78222c47@noble>
References: <cover.1438215986.git.shli@fb.com>
	<e871cc4fc266c76f1d4b55225f2c0a6aacb18680.1438215986.git.shli@fb.com>
	<20150804142824.GA8204@infradead.org>
	<C709E4D363AAB64590BFAC54D4C478AA0104B1CF0D@PRN-MBX02-4.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C709E4D363AAB64590BFAC54D4C478AA0104B1CF0D@PRN-MBX02-4.TheFacebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@fb.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Tue, 4 Aug 2015 18:17:25 +0000 Song Liu <songliubraving@fb.com>
wrote:

> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Tuesday, August 4, 2015 7:28 AM
> > To: Shaohua Li
> > Cc: linux-raid@vger.kernel.org; Kernel Team; Song Liu; hch@infradead.org;
> > dan.j.williams@intel.com; neilb@suse.de
> > Subject: Re: [PATCH 1/9] MD: add a new disk role to present cache device
> > 
> > >  		case 0xfffe: /* faulty */
> > >  			set_bit(Faulty, &rdev->flags);
> > >  			break;
> > > +		case 0xfffd: /* cache device */
> > 
> > Any chance to get constants for these magic numbers as an additional prep
> > patch?
> I will add patch for special roles (spare, faulty, cache, etc.). 
> 
> 
> > 
> > Also I don't really think that adding the role without the actual implementation
> > is that useful.
> 
> Currently, we are planning to use 0xfffd for both "cache device" and 
> "journal device" (fix write hole only). Would you prefer to separate these
> two scenarios with two different roles (0xfffd and 0xfffc)?

No, definitely not.  It is a log device.  whether it is being used just
to close the write hole or more aggressively as a write-ahead cache to
reduce latency doesn't change the nature of the data on the device.
So just one new device type: "log" or "journal" or something describing
what is on the device.

Thanks,
NeilBrown
