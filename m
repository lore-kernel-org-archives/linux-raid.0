From: Neil Brown <neilb@suse.de>
Subject: [PATCH-STABLE] Fix data-corruption bug in md when delayed recovery is interrupted.
Date: Wed, 19 Oct 2005 12:59:43 +1000
Message-ID: <17237.46751.709647.269732@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: stable@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  There is a bug in md/raid which is fixed by this patch.
  The patch should apply to almost any 2.6 kernel.
  A fix has already been submitted to akpm/linus for 2.6.14.
  This patch should be included in 2.6.13.5 (if there is one).

  The problem occurs if:
     two or more raid arrays share a physical device and
     two or more of them require recovery (onto a spare) and
     one or more is 'DELAYED' waiting for another to finish and
     the -resync thread receives SIGKILL, as can happen during
       shutdown (init send SIGKILL to everything) if the arrays are not
       first stopped with 'mdadm -Ss' or 'raidstop -a'.

   The problem is that the recovery will appear to be complete, but no
   data will have been copied onto the 'spare' drive that is now a
   full part of the array.  Naturally this can result in data
   corruption.

   To avoid this problem (until the patch is applied), do not shutdown
   a computer will any array that reports "resync=DELAYED" in
   /proc/mdstat - stop the array first with 'mdadm -Ss'.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-10-19 12:48:59.000000000 +1000
+++ ./drivers/md/md.c	2005-10-19 12:49:04.000000000 +1000
@@ -3486,6 +3486,7 @@ static void md_do_sync(mddev_t *mddev)
 	try_again:
 		if (signal_pending(current)) {
 			flush_signals(current);
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto skip;
 		}
 		ITERATE_MDDEV(mddev2,tmp) {
