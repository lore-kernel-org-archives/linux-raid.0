From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: Can "mdadm" linux RAID go large?
Date: Tue, 07 Jun 2005 16:53:38 -0700
Message-ID: <1118188418.15459.104.camel@seki.nac.uci.edu>
References: <1118187516.15459.93.camel@seki.nac.uci.edu>
	 <42A631C7.2060309@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A631C7.2060309@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: strombrg@dcs.nac.uci.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2005-06-07 at 16:46 -0700, Mike Hardy wrote:
> Not sure about the size limits per se
> (http://www.suse.de/~aj/linux_lfs.html has good info there)

Thanks for the link.

> I can say that with a very large number of disks, you will hit
> single-block read errors quite frequently due to the nature of the math
> behind MTBF. This will lead to frequent drive expulsion / rebuild
> cycles, as discussed in another thread today.

Say with 210 SATA's, for example?  Would I be replacing disks every day
or something?

> In another question (you could post them all as one mail,
> incidentally...)

True, but I've been hypothesizing that sometimes folks are reluctant to:

1) Wade all the way through a long series of questions

2) Respond to a message if they don't have the answers to all questions

>  you asked if it was stable. The only evidence appears
> to be anecdotal, but it appears extremely stable to me, even under very
> heavy testing - normal new machine cpu/network/ram burn-in tests,
> combined with multiple bonnie++ processes hitting the array. Any
> problems I've had have been attributable to hardware or hardware drivers
> thus far.

Good to know.

> There have been problems (like the recent set of looping-resync issues
> for instance), but I don't remember hearing any that resulted in data
> loss, and they get fixed quickly. Serious problems still leave you with
> your data on a set of disks in a known format, which means that it may
> be laborious but you can reconstruct. So it "degrades" more gracefully
> than the black box that are some hardware raid systems.

OK.

> It takes care to run well and safely though, as with any machine.

Yes, I'm expecting that.

Thanks!


