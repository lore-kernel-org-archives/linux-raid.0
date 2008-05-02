From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH] md: fix raid5 'repair' operations
Date: Fri, 2 May 2008 11:34:42 -0700
Message-ID: <e9c3a7c20805021134mf8e3101vc5efcae5fe0d035c@mail.gmail.com>
References: <20080502031513.13090.2973.stgit@dwillia2-linux.ch.intel.com>
	 <18458.49717.471295.285149@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18458.49717.471295.285149@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux@horizon.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 2, 2008 at 12:26 AM, Neil Brown <neilb@suse.de> wrote:
> On Thursday May 1, dan.j.williams@intel.com wrote:
>  > commit bd2ab67030e9116f1e4aae1289220255412b37fd "md: close a livelock
>  > window in handle_parity_checks5" introduced a bug in handling 'repair'
>  > operations.  After a repair operation completes we clear the state bits
>  > tracking this operation.  However, they are cleared too early and this
>  > results in the code deciding to re-run the parity check operation.  Since
>  > we have done the repair in memory the second check does not find a mismatch
>  > and thus does not do a writeback.
>
>  yes....
>  I must admit that I find that code fairly hard to make sense of, but I
>  can see how it was failing before and how this fixes it, and testing
>  confirms that, so I suspect it is right.
>
>  I cannot help feeling that there must be some way to simplify all
>  those .pending and .complete bits and make it somewhat clearer, but I
>  haven't been able to figure out how :-(
>

Agreed, the current scheme is not easily readable, and has proven
tricky to manipulate.  I will spend some cycles looking at this...

>  So: Acked-by: NeilBrown <neilb@suse.de>
>
>  I'm heading for a weekend, but feel free to send this to akpm.
>
>  Thanks,
>  NeilBrown
>

Thanks,
Dan
