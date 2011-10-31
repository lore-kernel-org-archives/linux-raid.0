From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/3] Remove dead code
Date: Mon, 31 Oct 2011 14:53:51 +0100
Message-ID: <1320069234-13112-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

These three patches remove a couple of chunks of dead code. They were
pointed out by running Coverity.

The dead code isn't a big issue in itself, but removing it will remove
noise when looking through the audit logs.

Cheers,
Jes


Jes Sorensen (3):
  conf_match(): Remove dead code
  conf_watch(): More dead code removal
  Kill(): Remove redundant check and dead code

 Kill.c   |    6 +-----
 config.c |   35 -----------------------------------
 2 files changed, 1 insertions(+), 40 deletions(-)

-- 
1.7.6.4

