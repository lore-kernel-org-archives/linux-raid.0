From: Jes.Sorensen@redhat.com
Subject: [PATCH 00/13] Add missing handling of malloc() failure
Date: Wed, 26 Oct 2011 17:30:13 +0200
Message-ID: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

I cam across a couple of these last week while I was chasing the
assemble problem of IMSM raids, so I started going through the code to
fix up some more of these.

This is just low hanging fruit, and there is more to be done, but at
least it's a few fixes.

Cheers,
Jes


Jes Sorensen (13):
  count_active() catch malloc() failure
  Catch malloc() failures
  Try to catch malloc() failures in Assemble.c
  Attempt to catch malloc() failure in Detail.c
  Handle malloc() failure in Examine.c
  Handle malloc() errors in Manage.c
  Fix malloc() failure handling in Monitor.c
  Handle malloc() failures in devline()
  Fix malloc handling in dlink.c
  Handle malloc() failure in Grow.c
  Handle malloc() failure in mdopen.c
  Handle malloc() failure in mdstat.c
  Catch malloc() failure

 Assemble.c    |   37 ++++++++++++++++++++-
 Detail.c      |   22 +++++++++++++
 Examine.c     |    5 +++
 Grow.c        |    7 ++++
 Incremental.c |    4 ++
 Manage.c      |   13 ++++++-
 Monitor.c     |    7 ++++
 config.c      |   99 ++++++++++++++++++++++++++++++++++++++++++---------------
 dlink.c       |    6 ++-
 mdopen.c      |    6 +++
 mdstat.c      |    5 +++
 policy.c      |    5 +++
 util.c        |   19 +++++++++--
 13 files changed, 200 insertions(+), 35 deletions(-)

-- 
1.7.6.4

