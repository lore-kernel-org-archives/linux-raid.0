From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/2] Test suite enhancements
Date: Tue, 22 May 2012 18:55:28 +0200
Message-ID: <1337705730-7335-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Two fixes for the testsuite. The first is just to allow it to run on
systems which do not include the multipath module. The second adds
command line arguments to 'test'. In particular it makes it possible
to specify explicit tests to run. I believe I managed to preserve the
behavior for old style arguments.

Cheers,
Jes


Jes Sorensen (2):
  Check for multipath module before running multipath tests
  Add command line argument parsing to 'test' sript

 test              |   94 ++++++++++++++++++++++++++++++++++++++++-------------
 tests/00multipath |    5 +++
 2 files changed, 76 insertions(+), 23 deletions(-)

-- 
1.7.7.6

