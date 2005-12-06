From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 002 of 14] Allow raid1 to check consistency
Date: Tue, 6 Dec 2005 14:50:46 +1100
Message-ID: <20051206145046.24114a9e.akpm@osdl.org>
References: <20051201141508.29384.patches@notabene>
	<1051201032256.29567@suse.de>
	<20051201143414.50ae2750.akpm@osdl.org>
	<17300.52648.463571.299921@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17300.52648.463571.299921@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:
>
> Would you accept:
>  ------------------
>  Signed-off-by: Neil Brown <neilb@suse.de>
> 
>  ### Diffstat output
>   ./mm/swap.c |    2 ++
>   1 file changed, 2 insertions(+)
> 
>  diff ./mm/swap.c~current~ ./mm/swap.c
>  --- ./mm/swap.c~current~	2005-12-06 10:29:16.000000000 +1100
>  +++ ./mm/swap.c	2005-12-06 10:29:25.000000000 +1100
>  @@ -36,6 +36,8 @@ int page_cluster;
>   
>   void put_page(struct page *page)
>   {
>  +	if (unlikely(page==NULL))
>  +		return;
>   	if (unlikely(PageCompound(page))) {
>   		page = (struct page *)page_private(page);
>   		if (put_page_testzero(page)) {
> 

eek.  That's an all-over-the-place-fast-path!

> 
>  Or should I open code this in md ?

Yes please.
