From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH git-md-accel 0/2] raid5 refactor, and pr_debug cleanup
Date: Mon, 18 Jun 2007 14:07:19 -0700
Message-ID: <20070618210546.19865.7170.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

The following two patches are the respin of the changes you suggested to
"raid5: coding style cleanup / refactor".  I have added them to the
git-md-accel tree for a 2.6.23-rc1 pull.  The full, rebased, raid
acceleration patchset will be sent for a another round of review once I
address Andrew's concerns about the commit messages.

Dan Williams (2):
      raid5: refactor handle_stripe5 and handle_stripe6
      raid5: replace custom debug print with standard pr_debug
