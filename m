From: BillStuff <billstuff2001@sbcglobal.net>
Subject: Re: [GIT PULL REQUEST] late md/raid1 bug fixes for 3.17
Date: Fri, 26 Sep 2014 14:08:08 -0500
Message-ID: <5425B998.7080304@sbcglobal.net>
References: <20140924121805.1b8c3bd9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140924121805.1b8c3bd9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/23/2014 09:18 PM, NeilBrown wrote:
[snip]
>        md/raid1: intialise start_next_window for READ case to avoid hang
>

Neil, I've been testing these patches for the past week or two to see if 
they help a raid1 "check" hang I had.

They seem to help, but I noticed the above patch is different from what 
you originally sent on the list.

The original patch has an extra chunk:

@@ -1444,6 +1445,7 @@ read_again:
		r1_bio->state = 0;
		r1_bio->mddev = mddev;
		r1_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
+		start_next_window = wait_barrier(conf, bio);
		goto retry_write;
	}

Is the correct patch with or without this chunk?

Thanks,
Bill
