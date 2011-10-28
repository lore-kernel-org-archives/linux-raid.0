From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/2] Misc fixes
Date: Fri, 28 Oct 2011 21:50:49 +0200
Message-ID: <1319831451-26704-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Two fixes:

The first is to avoid a use-after-free case. I looked at this one for
a while, and I believe this is the intention of the code. Ie. once we
find the first entry, bail out to the end rather than going back
re-iterating over the list that we just freed.

The second to avoid the case where a GPT partition table entry is
larger than 128 bytes, in which case we would read it and corrupt the
stack.

Jes Sorensen (2):
  Avoid use after free
  Avoid stack overflow if GPT partition entries on disk are > 128 bytes

 util.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

-- 
1.7.6.4

