Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4301C83F2C
	for <linux-raid@archiver.kernel.org>; Sun,  3 Sep 2023 13:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbjICNbR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Sep 2023 09:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbjICNbQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Sep 2023 09:31:16 -0400
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46180FA
        for <linux-raid@vger.kernel.org>; Sun,  3 Sep 2023 06:31:12 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id 908714006E;
        Sun,  3 Sep 2023 13:31:08 +0000 (UTC)
Date:   Sun, 3 Sep 2023 18:30:58 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Kuan-Wei Chiu <visitorckw@gmail.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/raid5: eliminate if-statements in cmp_stripe()
Message-ID: <20230903183058.1301b149@nvm>
In-Reply-To: <20230903095059.2683850-1-visitorckw@gmail.com>
References: <20230903095059.2683850-1-visitorckw@gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun,  3 Sep 2023 17:50:59 +0800
Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> Replace the conditional statements in the cmp_stripe() function with a
> branchless version to improve code readability and potentially enhance
> performance.

The new code will always do two comparisons and a subtraction (3
instructions in total), whereas the old version could return after just 1
comparison, or after 2 comparisons. So depending on the data values it is 3x
to 1.5x as much operations performed than before, there unlikely to be any
enhancement of performance.

Also IMO the previous version is more easily readable.

> The new code calculates the result using a subtraction of
> comparison results, making it more concise and avoiding conditional
> branches. This change does not alter the functionality of the code.
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
>  drivers/md/raid5.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 4cb9c608ee19..b14d7ba38f0f 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1035,11 +1035,7 @@ static int cmp_stripe(void *priv, const struct list_head *a,
>  				struct r5pending_data, sibling);
>  	const struct r5pending_data *db = list_entry(b,
>  				struct r5pending_data, sibling);
> -	if (da->sector > db->sector)
> -		return 1;
> -	if (da->sector < db->sector)
> -		return -1;
> -	return 0;
> +	return (da->sector > db->sector) - (da->sector < db->sector);
>  }
>  
>  static void dispatch_defer_bios(struct r5conf *conf, int target,


-- 
With respect,
Roman
