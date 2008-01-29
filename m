From: Neil Brown <neilb@suse.de>
Subject: Re: BUG: possible array corruption when adding a component to a degraded
 raid5 (possibly other levels too)
Date: Tue, 29 Jan 2008 11:38:00 +1100
Message-ID: <18334.30056.611260.951887@notabene.brown>
References: <479DA8E6.6040209@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Rabbitson on Monday January 28
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 28, rabbit+list@rabbit.us wrote:
> Hello,
> 
> It seems that mdadm/md do not perform proper sanity checks before adding a 
> component to a degraded array. If the size of the new component is just right, 
> the superblock information will overlap with the data area. This will happen 
> without any error indications in the syslog or otherwise.
> 
> I came up with a reproducible scenario which I am attaching to this email 
> alongside with the entire test script. I have not tested it for other raid 
> levels, or other types of superblocks, but I suspect the same problem will 
> occur for many other configurations.
> 
> I am willing to test patches, however the attached script is non-intrusive 
> enough to be executed anywhere.

Thanks for the report and the test script.

This patch for mdadm should fix this problem.... I hate the fact that
we sometimes use K and sometimes use sectors for
sizes/offsets... groan.

I'll probably get a test in the kernel as well to guard against this.

Thanks,
NeilBrown


### Diffstat output
 ./Manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/Manage.c ./Manage.c
--- .prev/Manage.c	2008-01-29 11:15:54.000000000 +1100
+++ ./Manage.c	2008-01-29 11:16:15.000000000 +1100
@@ -337,7 +337,7 @@ int Manage_subdevs(char *devname, int fd
 
 				/* Make sure device is large enough */
 				if (tst->ss->avail_size(tst, ldsize/512) <
-				    array.size) {
+				    array.size*2) {
 					fprintf(stderr, Name ": %s not large enough to join array\n",
 						dv->devname);
 					return 1;
