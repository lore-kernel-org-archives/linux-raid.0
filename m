From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/2] Tests for add/remove of internal bitmaps
Date: Tue, 29 May 2012 17:09:57 +0200
Message-ID: <1338304199-6047-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Sometime ago Neil fixed a bug where the kernel would OOPS when adding
a bitmap to an existing array and using it immediately. We hit this
more recently in RHEL so I figured I better write a proper testcase
for it.

The second patch is checking that removing bitmaps also works, though
I didn't have a specific case triggered by that. I just added them for
completeness.

I added the patches to the 05 prefix as that is where the other bitmap
related test cases were. Feel free to reassign them if you like.

Cheers,
Jes
 

Jes Sorensen (2):
  New tests testing the addition of bitmaps
  New tests testing removal of internal bitmaps

 tests/05r1-add-internalbitmap        |   20 ++++++++++++++++++++
 tests/05r1-add-internalbitmap-v1a    |   20 ++++++++++++++++++++
 tests/05r1-add-internalbitmap-v1b    |   20 ++++++++++++++++++++
 tests/05r1-add-internalbitmap-v1c    |   20 ++++++++++++++++++++
 tests/05r1-remove-internalbitmap     |   18 ++++++++++++++++++
 tests/05r1-remove-internalbitmap-v1a |   18 ++++++++++++++++++
 tests/05r1-remove-internalbitmap-v1b |   18 ++++++++++++++++++
 tests/05r1-remove-internalbitmap-v1c |   18 ++++++++++++++++++
 8 files changed, 152 insertions(+)
 create mode 100644 tests/05r1-add-internalbitmap
 create mode 100644 tests/05r1-add-internalbitmap-v1a
 create mode 100644 tests/05r1-add-internalbitmap-v1b
 create mode 100644 tests/05r1-add-internalbitmap-v1c
 create mode 100644 tests/05r1-remove-internalbitmap
 create mode 100644 tests/05r1-remove-internalbitmap-v1a
 create mode 100644 tests/05r1-remove-internalbitmap-v1b
 create mode 100644 tests/05r1-remove-internalbitmap-v1c

-- 
1.7.10.2

