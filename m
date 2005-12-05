From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.15-rc5-mm1: raid related oops
Date: Tue, 6 Dec 2005 10:33:21 +1100
Message-ID: <17300.52801.734773.284847@cse.unsw.edu.au>
References: <20051205195004.GA11243@amd64.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964873AbVLEXdq@vger.kernel.org>
In-Reply-To: message from jurriaan on Monday December 5
Sender: linux-kernel-owner@vger.kernel.org
To: Jurriaan <thunder7@xs4all.nl>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Monday December 5, thunder7@xs4all.nl wrote:
> Written by hand:
> 
> Null pointer dereference
> last sysfs file /block/md0/md/sync_action
> put_page

ohh dear, it seems that, unlike kfree, put_page doesn't like 'NULL' as
an argument.

You can try
------------------
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

-------------------
for now.  If Andrew doesn't like that I'll make the code in raid1
more careful (maybe I'll define put_page_unless_null :-)

Thanks for the testing and the report.

NeilBrown
