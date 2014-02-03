From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid1 repair does not repair errors?
Date: Mon, 03 Feb 2014 11:30:40 +0400
Message-ID: <52EF45A0.3010401@msgid.tls.msk.ru>
References: <52EE3910.3040205@msgid.tls.msk.ru> <20140203120431.400a8a1b@notabene.brown> <20140203153644.4c530672@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140203153644.4c530672@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

03.02.2014 08:36, NeilBrown wrote:
[]
> Actually I've changed my mind.  That patch won't fix anything.
> fix_sync_read_error() is focussed on fixing a read error on ->read_disk.
> So we only set uptodate if ->read_disk succeeded.
> 
> So this patch should do it.
> 
> NeilBrown
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index fd3a2a14b587..0fe5fd469e74 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1733,7 +1733,8 @@ static void end_sync_read(struct bio *bio, int error)
>  	 * or re-read if the read failed.
>  	 * We don't do much here, just schedule handling by raid1d
>  	 */
> -	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> +	if (bio == r1_bio->bios[r1_bio->read_disk] &&
> +	    test_bit(BIO_UPTODATE, &bio->bi_flags))
>  		set_bit(R1BIO_Uptodate, &r1_bio->state);
>  
>  	if (atomic_dec_and_test(&r1_bio->remaining))
> 

I changed it like this for now:

--- ../linux-3.10/drivers/md/raid1.c	2014-02-02 16:01:55.003119836 +0400
+++ drivers/md/raid1.c	2014-02-03 11:26:59.062845829 +0400
@@ -1634,8 +1634,12 @@ static void end_sync_read(struct bio *bi
 	 * or re-read if the read failed.
 	 * We don't do much here, just schedule handling by raid1d
 	 */
-	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
-		set_bit(R1BIO_Uptodate, &r1_bio->state);
+	if (bio == r1_bio->bios[r1_bio->read_disk]) {
+	    if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+ 		set_bit(R1BIO_Uptodate, &r1_bio->state);
+	    else
+		printk("end_sync_read: our bio, but !BIO_UPTODATE\n");
+	}

 	if (atomic_dec_and_test(&r1_bio->remaining))
 		reschedule_retry(r1_bio);

and will test it later today (in about 10 hours from now) -- as I
mentioned, this is a prod box and testing isn't possible anytime.

Thank you for looking into this.  Hopefully it will work better now :)

/mjt
