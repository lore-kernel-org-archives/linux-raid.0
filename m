From: "Eric D. Mudama" <edmudama@gmail.com>
Subject: Re: NCQ general question
Date: Sat, 4 Mar 2006 16:56:16 -0700
Message-ID: <311601c90603041556oce5a50ev8379ea39fa7b65cc@mail.gmail.com>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com>
	 <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca>
	 <20060301135547.GV4816@suse.de>
	 <C6838977-5411-400F-9548-2F22598DC2AE@egenera.com>
	 <4408C0D9.4010202@garzik.org>
	 <98B59AFC-2781-4A8A-82E4-C923B4A48F9E@egenera.com>
	 <4409E623.5070707@garzik.org>
	 <C7155197-3E90-4EDF-9D1A-5A5210248938@egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C7155197-3E90-4EDF-9D1A-5A5210248938@egenera.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Steve Byan <smb@egenera.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <axboe@suse.de>, Mark Lord <liml@rtr.ca>, Gentoopower <gentoopower@yahoo.de>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On 3/4/06, Steve Byan <smb@egenera.com> wrote:
> On Mar 4, 2006, at 2:10 PM, Jeff Garzik wrote:
> > Measurements on NCQ in the field show a distinct performance
> > improvement...  30% has been measured on Linux.  Nothing to sneeze at.
>
> Wow! 30% is amazing. I'd be interested in knowing how the costs break
> down; are these measurements published anywhere?

Full-stroke random reads with small operations (4k or less) typically
show 75-85% performance improvement, from the ability of a 7200rpm
drive to carve 4ms out of their response time, as well as a huge chunk
of seek distance.

Random writes, since as you said they're already reordered with cache
enabled, don't typically show any sort of increase in desktop
applications.

NCQ FUA writes or NCQ writes with cache disabled should show the same
ballpark performance improvement as random reads in saturated
workloads.  Again however, this is for the full-stroke random case. 
Local area workloads need to be analyzed more thoroughly, and may
differ in performance gain by manufacturer.

--eric
