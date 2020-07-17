From: Xiao Ni <xni@redhat.com>
Subject: [PATCH RFC 0/3] Improve handling raid10 discard request
Date: Fri, 17 Jul 2020 10:52:45 +0800
Message-ID: <1594954368-5646-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: song@kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

Now mkfs on raid10 which is combined with ssd/nvme disks takes a long time.
This patch set tries to resolve this problem.

Xiao Ni (3):
  Move codes related with submitting discard bio into one function
  extend r10bio devs to raid disks
  improve raid10 discard request

 drivers/md/md.c     |  22 +++++
 drivers/md/md.h     |   3 +
 drivers/md/raid0.c  |  15 +--
 drivers/md/raid10.c | 276 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 297 insertions(+), 19 deletions(-)

-- 
2.7.5
