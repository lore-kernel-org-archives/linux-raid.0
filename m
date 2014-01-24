From: keld@keldix.com
Subject: Re: Why are reads not balanced across my RAID-1?
Date: Fri, 24 Jan 2014 18:49:04 +0100
Message-ID: <20140124174904.GA6884@www5.open-std.org>
References: <20140124104757.8256.qmail@science.horizon.com> <20140124120448.GA19163@www5.open-std.org> <CAJvUf-BfK-CeLFZ3WmRFbSpjr_x8x1FO7pDX5gmAJyw2RpekxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJvUf-BfK-CeLFZ3WmRFbSpjr_x8x1FO7pDX5gmAJyw2RpekxA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: George Spelvin <linux@horizon.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jan 24, 2014 at 08:56:02AM -0600, Matt Garman wrote:
> On Fri, Jan 24, 2014 at 6:04 AM,  <keld@keldix.com> wrote:
> > The reading is not balanced because it does not make sense to do balanced
> > reads for sequential reading. In RAID-1 the disk sectors are consequitive.
> > So if you would read one sector from one disk, and the following sector from the other disk,
> > then the next read from disk 1 would need to skip a full resolvation of the disk,
> > which may cost something like 8 ms.  So better read contigously from the same disk, and hope
> > for some other IO request that can use disk 2.
> 
> 
> Does that rationale hold for SSDs?

No, this is not relevant for SSDs as access time is almost zero.

best regards
keld
