From: Andrew Walrond <andrew@walrond.org>
Subject: Re: No swap can be dangerous (was Re: swap on RAID (was Re: swp - Re: ext3 journal on software raid))
Date: Fri, 7 Jan 2005 09:28:13 +0000
Message-ID: <200501070928.13307.andrew@walrond.org>
References: <200501062316.j06NFP900855@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501062316.j06NFP900855@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Guy <bugzilla@watkins-home.com>, 'Mike Hardy' <mhardy@h3c.com>, 'Jesper Juhl' <juhl-lkml@dif.dk>, linux-raid@vger.kernel.org, alan@lxorguk.ukuu.org.uk
List-Id: linux-raid.ids

On Thursday 06 January 2005 23:15, Guy wrote:
> If I MUST/SHOULD have swap space....
> Maybe I will create a RAM disk and use it for swap!  :)  :)  :)

Well, indeed, I had the same thought. As long as you could guarantee that the 
ram was of the highmem/non-dmaable type...

But we're getting ahead of ourselves. I think we need an authoritive answer to 
the original premise. Perhaps Alan (cc-ed) might spare us a moment?

Did I dream this up, or is it correct?

"I think the gist was this: the kernel can sometimes needs to move bits of 
memory in order to free up dma-able ram, or lowmem. If I recall correctly, 
the kernel can only do this move via swap, even if there is stacks of free 
(non-dmaable or highmem) memory."

Andrew
