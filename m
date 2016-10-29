From: Roman Mamedov <rm@romanrm.net>
Subject: Re: recovering failed raid5
Date: Sat, 29 Oct 2016 15:29:51 +0500
Message-ID: <20161029152951.62add3ca@natsu>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133304.GA11564@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161028133304.GA11564@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 28 Oct 2016 15:33:04 +0200
Andreas Klauer <Andreas.Klauer@metamorpher.de> wrote:

> On Fri, Oct 28, 2016 at 01:22:31PM +0100, Alexander Shenkin wrote:
> > One remaining question: is sdc definitely toast?
> 
> In my opinion a drive is toast starting from the very first reallocated/ 
> pending/uncorrectable sector, your drive has several of those and that's 
> only the ones the drive already knows about - there may be more.

I'd say you are overly cautious on this. Yes there are drives for which one
reallocated sector is a sign of the coming avalanche of them, but then there
are also ones (e.g. my Hitachi 2TB) which work for years, over than period
develop 3-5-7 reallocated sectors, and THAT'S IT, they just continue to work.
And if there's an unreadable sector on rebuild as a drive found its 8th bad
sector after 3 more years of perfect operation, that's not a problem either,
because the setup they run in, is RAID6. (Not to compensate for this, but I
wouldn't be running a 8-10 drive RAID5 in any case).

-- 
With respect,
Roman
