From: Zhilong Liu <zlliu@suse.com>
Subject: [RFC PATCH 00/13] mdadm/test: Basic improvement for some cases
Date: Fri,  1 Dec 2017 17:48:01 +0800
Message-ID: <1512121694-18168-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi Jes,

The patches mainly did basic improvement for some test cases,
include of redraft 'Create' cases, add new case for test raid10
resize and fix failure cases.

This patch list just a demo, in order to ease for review, I
wrap it one case by one commit.

Welcome to do further discussion, and point out where need to
improve more.

And here paste the 'time' result with current changing, I'm not
sure whether or not the $(time) result is acceptable.

linux-apta:~/mdadm-test # for i in $(ls tests); do time ./test --tests=$i; done
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/00names... succeeded

real	0m13.504s
user	0m0.323s
sys	0m1.076s
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/00raid1... succeeded

real	1m0.990s
user	0m0.851s
sys	0m1.319s
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/00raid10... succeeded

real	7m56.384s
user	0m4.562s
sys	0m3.744s
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/00raid4... succeeded

real	1m10.928s
user	0m0.903s
sys	0m1.400s
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/00raid5... succeeded

real	9m59.301s
user	0m6.273s
sys	0m4.171s
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/00raid6... succeeded

real	1m10.823s
user	0m0.966s
sys	0m1.329s
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/02r10grow-resize... succeeded

real	2m32.888s
user	0m1.445s
sys	0m1.529s
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/02r5grow-resize... succeeded

real	0m28.764s
user	0m0.483s
sys	0m1.163s
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/02r6grow-resize... succeeded

real	0m20.796s
user	0m0.373s
sys	0m1.142s
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/05r1-internalbitmap... succeeded

real	0m30.596s
user	0m0.312s
sys	0m1.137s
Testing on linux-4.14.0-rc6-git-latest+ kernel
tests/05r1-n3-bitmapfile... succeeded

real	0m28.768s
user	0m0.324s
sys	0m1.128s

Thanks,
Zhilong

Zhilong Liu (13):
  mdadm/manpage: raid10 doesn't support resize 'far' arrays
  mdadm/test: did basic improvement for 00names
  mdadm/test: redraft the 00raid1 test case
  mdadm/test: redraft 00raid4 test case
  mdadm/test: redraft the 00raid5 test case
  mdadm/test: redraft the 00raid6 test case
  mdadm/test: redraft the 00raid10 test case
  mdadm/test: redraft 02r5grow and rename it as 02r5grow-resize
  mdadm/test: redraft 02r6grow and rename it as 02r6grow-resize
  mdadm/test: add new test 02r10grow-resize
  mdadm/test: did basic improvement for 05r1-internalbitmap
  mdadm/test: did basic improvement for 05r1-n3-bitmapfile
  mdadm/test: Change check nosync as check recovery in
    05r1-re-add-nosuper

 mdadm.8.in                |   2 +-
 tests/00names             |  13 +++---
 tests/00raid1             |  23 ++++++++---
 tests/00raid10            |  41 ++++++++++++------
 tests/00raid4             |  26 +++++++++---
 tests/00raid5             |  51 ++++++++++++-----------
 tests/00raid6             |  27 +++++++-----
 tests/02r10grow-resize    | 103 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/02r5grow            |  53 ------------------------
 tests/02r5grow-resize     |  85 ++++++++++++++++++++++++++++++++++++++
 tests/02r6grow            |  36 ----------------
 tests/02r6grow-resize     |  69 +++++++++++++++++++++++++++++++
 tests/05r1-internalbitmap |  26 ++++++++----
 tests/05r1-n3-bitmapfile  |  25 +++++++----
 tests/05r1-re-add-nosuper |  16 ++++++-
 15 files changed, 422 insertions(+), 174 deletions(-)
 create mode 100644 tests/02r10grow-resize
 delete mode 100644 tests/02r5grow
 create mode 100644 tests/02r5grow-resize
 delete mode 100644 tests/02r6grow
 create mode 100644 tests/02r6grow-resize

-- 
1.8.5.6

