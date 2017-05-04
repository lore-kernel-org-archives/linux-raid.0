From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: RAID creation resync behaviors
Date: Thu, 4 May 2017 09:55:51 +0200
Message-ID: <20170504075551.GA3929@metamorpher.de>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
 <20170503235856.GA9698@metamorpher.de>
 <20170504022258.eov6xh2zwtbfvcch@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170504022258.eov6xh2zwtbfvcch@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

On Wed, May 03, 2017 at 07:22:58PM -0700, Shaohua Li wrote:
> 
> Unfortunately not all SSD return zero after trim.
>  

For example? I was under the impression that pretty much all of them do. 
Even the ones that don't advertize it returned zero after trim for me. 
[Sometimes you get original data but that's Linux; gone after drop_caches]
(Of course, I don't have access to that many different models of SSD...)

But what do they actually return then? Original data? This might seem 
fine at first but it can't be the case, right? I mean, even if the SSD 
does not erase a trimmed block right away, sooner or later it would, 
in order to re-use it for new data and wear leveling. If it's never 
re-used what is the point of trimming it in the first place?

So it seems to me even if an SSD attempted to keep returning original data 
for a while, sooner or later it would be gone and if that happens randomly, 
as far as your RAID is concerned you will be in mismatch hell anyways. 
So after a full trim, you can skip the initial sync either way.

Mismatches might also be an issue for SSD that do return zero after trim, 
but have different erase block sizes / trim boundaries / partition offsets.
Or does read zero after trim actually mean it works at 4K page resolution? 
Never mind, then. :-)

Regards
Andreas Klauer
