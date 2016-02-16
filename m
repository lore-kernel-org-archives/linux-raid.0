From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: [PATCH 0/2] md/mdadm: Inform udev about device removal when stopping
Date: Tue, 16 Feb 2016 15:44:35 +0100
Message-ID: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com>
Reply-To: linux-raid <linux-raid@vger.kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Shaohua Li <shli@kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, NeilBrown <neilb@suse.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

When stopping an MD device, then its device node /dev/mdX may still
exist afterwards or it is recreated by udev. The next open() call
can lead to creation of an inoperable MD device. The reason for
this is that a change event (KOBJ_CHANGE) is announced to udev.
So announce a removal event (KOBJ_REMOVE) to udev instead.

Because of the support for kernels prior to 2.6.28, this change is
required in mdadm and the kernel. The udev event from mdadm
overrides the one from the kernel.

Sebastian Parschauer (2):
  md: Inform udev about device removal when stopping
  Manage: Inform udev about device removal when stopping

 drivers/md/md.c |    2 +-
 Manage.c        |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)
