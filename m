From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid-6 hang on write.
Date: Mon, 28 Feb 2005 16:49:59 +1100
Message-ID: <16930.45319.682534.351648@cse.unsw.edu.au>
References: <421DE9A9.4090902@wasp.net.au>
	<421F4629.5080309@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Brad Campbell on Friday February 25
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: lkml <linux-kernel@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday February 25, brad@wasp.net.au wrote:
> 
> Turning on debugging in raid6main.c and md.c make it much harder to hit. So I'm assuming something 
> timing related.
> 
> raid6d --> md_check_recovery --> generic_make_request --> make_request --> get_active_stripe

Yes, there is a real problem here.  I see if I can figure out the best
way to remedy it...
However I think you reported this problem against a non "-mm" kernel,
and the path from md_check_recovery to generic_make_requests only
exists in "-mm".

Could you please confirm if there is a problem with
    2.6.11-rc4-bk4->bk10

as reported, and whether it seems to be the same problem.

Thanks,
NeilBrown
