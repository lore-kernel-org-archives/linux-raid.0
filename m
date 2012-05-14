From: Jes.Sorensen@redhat.com
Subject: [PATCH v2 0/1] test suite - check for multipath available before running multipath tests
Date: Mon, 14 May 2012 22:26:59 +0200
Message-ID: <1337027220-17342-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Ok this one actually does the right thing and works for me on systems
where multipath is present.

Cheers,
Jes

Jes Sorensen (1):
  Check for multipath module before running multipath tests

 test              |    6 ++++++
 tests/00multipath |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

-- 
1.7.7.6

