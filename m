From: Neil Brown <neilb@suse.de>
Subject: Re: PROBLEM: RAID5 reshape data corruption
Date: Fri, 4 Jan 2008 09:37:24 +1100
Message-ID: <18301.25508.789841.621017@notabene.brown>
References: <20071231130420.kivbehcc0o0wk008@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nagilum on Monday December 31
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

On Monday December 31, nagilum@nagilum.org wrote:
> Ok, since my previous thread didn't seem to attract much attention,
> let me try again.

Thank you for your report and your patience.

> An interrupted RAID5 reshape will cause the md device in question to
> contain one corrupt chunk per stripe if resumed in the wrong manner.
> A testcase can be found at http://www.nagilum.de/md/ .
> The first testcase can be initialized with "start.sh" the real test
> can then be run with "test.sh". The first testcase also uses dm-crypt
> and xfs to show the corruption.

It looks like this can be fixed with the patch:

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-01-04 09:20:54.000000000 +1100
+++ ./drivers/md/raid5.c	2008-01-04 09:21:05.000000000 +1100
@@ -2865,7 +2865,7 @@ static void handle_stripe5(struct stripe
 		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 	}
 
-	if (s.expanding && s.locked == 0)
+	if (s.expanding && s.locked == 0 && s.req_compute == 0)
 		handle_stripe_expansion(conf, sh, NULL);
 
 	if (sh->ops.count)


With this patch in place, the v2 test only reports errors after the end
of the original array, as you would expect (the new space is
initialised to 0).

> I'm not just interested in a simple behaviour fix I'm also interested
> in what actually happens and if possible a repair program for that
> kind of data corruption.

What happens is that when reshape happens while a device is missing,
the data on that device should be computed from the other data devices
and parity.  However because of the above bug, the data is copied into
the new layout before the compute is complete.  This means that the
data that was on that device is really lost beyond recovery.

I'm really sorry about that, but there is nothing that can be done to
recover the lost data.

NeilBrown
