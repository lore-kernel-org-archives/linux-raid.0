From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/4] More test suite enchancements
Date: Fri, 25 May 2012 17:24:04 +0200
Message-ID: <1337959448-5299-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Here's another set of test suite enhancements. In particular I have
added --logdir and --save-logs, plus --no-error  which allows for one
to run all the tests, without stopping after the first error. This
makes it easier to run the test suite in an automated fashion and
getting a report of all the tests that may have failed. I also did a
bit to make the --help output more useful.

Cheers,
Jes

Jes Sorensen (4):
  Add support for saving log files in test script
  Add --no-error argument to 'test'
  Improve --help message from test
  Move setup code to a function and introduce matching cleanup argument

 test |  113 ++++++++++++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 82 insertions(+), 31 deletions(-)

