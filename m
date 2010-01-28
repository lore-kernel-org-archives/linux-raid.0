From: Artur Wojcik <artur.wojcik@intel.com>
Subject: [mdadm PATCH 0/2] Improvement: new logging library for mdadm/mdmon
Date: Thu, 28 Jan 2010 17:04:04 +0100
Message-ID: <20100128155922.32091.12709.stgit@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

The following two patches contains the new method of logging messages
in mdadm and mdmon applications. The first patch is just the library,
and the second patch is the proposal on how to use the library in the
applications.

As for the library, please let me know if detailed explanation is required.

---

Artur Wojcik (2):
      Improvement: new logging facility.
      Improvement: Replace fprintf functions with log_* functions.


 Assemble.c    |  382 +++++++++++++++--------------------
 Build.c       |   65 +++---
 Create.c      |  206 ++++++++-----------
 Detail.c      |   39 ++--
 Examine.c     |   11 +
 Grow.c        |  333 +++++++++++++++++-------------
 Incremental.c |  229 ++++++++-------------
 Kill.c        |   21 +-
 Makefile      |    6 -
 Manage.c      |  163 ++++++---------
 Monitor.c     |  107 +++++-----
 Query.c       |    2
 ReadMe.c      |   18 ++
 bitmap.c      |   35 +--
 config.c      |  142 ++++++-------
 log.c         |  625 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 log.h         |  148 +++++++++++++
 managemon.c   |   10 -
 mdadm.c       |  556 +++++++++++++++++++++++++++++++++++----------------
 mdadm.h       |   78 ++++---
 mdmon.c       |   45 ++--
 mdopen.c      |   39 ++--
 mdstat.c      |    2
 monitor.c     |   29 +--
 super-ddf.c   |  185 +++++++----------
 super-intel.c |  366 ++++++++++++++-------------------
 super0.c      |   68 ++----
 super1.c      |   53 ++---
 sysfs.c       |   24 +-
 test          |    0
 util.c        |   22 +-
 31 files changed, 2396 insertions(+), 1613 deletions(-)
 create mode 100644 log.c
 create mode 100644 log.h
 mode change 100644 => 100755 test

---
Artur Wojcik
