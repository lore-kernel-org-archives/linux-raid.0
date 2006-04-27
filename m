From: Neil Brown <neilb@suse.de>
Subject: Re: Trying to start dirty, degraded RAID6 array
Date: Thu, 27 Apr 2006 10:06:21 +1000
Message-ID: <17488.2813.780066.749611@cse.unsw.edu.au>
References: <44500439.1020108@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christopher Smith on Thursday April 27
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 27, csmith@nighthawkrad.net wrote:
> The short version:
> 
> I have a 12-disk RAID6 array that has lost a device and now whenever I 
> try to start it with:
> 
> mdadm -Af /dev/md0 /dev/sd[abcdefgijkl]1
> 
> I get:
> 
> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
> 
...
> raid6: cannot start dirty degraded array for md0

The '-f' is meant to make this work.  However it seems there is a bug.

Could you please test this patch?  It isn't exactly the right fix, but
it definitely won't hurt.

Thanks,
NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./super0.c |    1 +
 1 file changed, 1 insertion(+)

diff ./super0.c~current~ ./super0.c
--- ./super0.c~current~	2006-03-28 17:10:51.000000000 +1100
+++ ./super0.c	2006-04-27 10:03:40.000000000 +1000
@@ -372,6 +372,7 @@ static int update_super0(struct mdinfo *
 		if (sb->level == 5 || sb->level == 4 || sb->level == 6)
 			/* need to force clean */
 			sb->state |= (1 << MD_SB_CLEAN);
+		rv = 1;
 	}
 	if (strcmp(update, "assemble")==0) {
 		int d = info->disk.number;
