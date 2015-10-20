From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/2] raid1/10: Handle write errors correctly in narrow_write_error()
Date: Tue, 20 Oct 2015 12:09:11 -0400
Message-ID: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, kent.overstreet@gmail.com, William.Kuzeja@stratus.com, xni@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Bill Kuzeja reported a problem to me about data corruption when
repeatedly removing and re-adding devices in raid1 arrays. It showed
up to be caused by the return value of submit_bio_wait() being handled
incorrectly. Tracking this down is credit of Bill!

Looks like commit 9e882242c6193ae6f416f2d8d8db0d9126bd996b changed the
return of submit_bio_wait() to return != 0 on error, whereas before it
returned 0 on error.

This fix should be suitable for -stable as far back as 3.9

Cheers,
Jes

Jes Sorensen (2):
  md/raid1: submit_bio_wait() returns 0 on success
  md/raid10: submit_bio_wait() returns 0 on success

 drivers/md/raid1.c  | 2 +-
 drivers/md/raid10.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.4.3

