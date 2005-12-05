From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md 002 of 14] Allow raid1 to check consistency
Date: Tue, 6 Dec 2005 10:30:48 +1100
Message-ID: <17300.52648.463571.299921@cse.unsw.edu.au>
References: <20051201141508.29384.patches@notabene>
	<1051201032256.29567@suse.de>
	<20051201143414.50ae2750.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Thursday December 1
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 1, akpm@osdl.org wrote:
> NeilBrown <neilb@suse.de> wrote:
> >   out_free_pages:
> >  -	for ( ; i > 0 ; i--)
> >  -		__free_page(bio->bi_io_vec[i-1].bv_page);
> >  +	for (i=0; i < RESYNC_PAGES ; i++)
> >  +		for (j=0 ; j < pi->raid_disks; j++)
> >  +			__free_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
> >  +	j = -1;
> >   out_free_bio:
> 
> Are you sure the error handling here is correct?

Uhmm.. maybe?

> 
> a) we loop up to RESYNC_PAGES, but the allocation loop may not have got
>    that far
> 
> b) we loop in the ascending-index direction, but the allocating loop
>    loops in the descending-index direction.
> 
> c) we loop up to pi->raid_disks, but the allocating loop may have
>    done `j = 1;'.

As it is a well-known fact that all deallocation routines in Linux
accept a NULL argument, and as error handling is not a critical path,
and as the structures are zeroed when allocated, I chose simply to
free every possibly allocated page rather than keep track of exactly
where we were up to.
Unfortunately not all well-known facts are true :-(

> 
> d) there was a d), but I forgot what it was.

Maybe 'd' was  
   __free_page does not accept 'NULL' as an argument, though 
   free_page does (but it wants an address I think...).

But I have since changed this code to use "put_page", and put_page
doesn't like NULL either..

Would you accept:
------------------
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./mm/swap.c |    2 ++
 1 file changed, 2 insertions(+)

diff ./mm/swap.c~current~ ./mm/swap.c
--- ./mm/swap.c~current~	2005-12-06 10:29:16.000000000 +1100
+++ ./mm/swap.c	2005-12-06 10:29:25.000000000 +1100
@@ -36,6 +36,8 @@ int page_cluster;
 
 void put_page(struct page *page)
 {
+	if (unlikely(page==NULL))
+		return;
 	if (unlikely(PageCompound(page))) {
 		page = (struct page *)page_private(page);
 		if (put_page_testzero(page)) {

--------------------

Or should I open code this in md ?

NeilBrown
