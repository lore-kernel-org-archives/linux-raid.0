From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] Incremental() additional locking fixes
Date: Fri, 21 Oct 2011 18:21:37 +0200
Message-ID: <1319214098-10409-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This one goes on top of my previous set of changes to the locking
hierachy in Incremental(). I basically noticed that in most places, an
error in Incremental() would error out without releasing the lock.

Cheers,
Jes


Jes Sorensen (1):
  Incremental() lock error handling

 Incremental.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

-- 
1.7.4.4

