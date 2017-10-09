From: Zhilong Liu <zlliu@suse.com>
Subject: [mdadm PATCH 0/3] fixed broken level conversion and one strncmp issue
Date: Mon,  9 Oct 2017 16:21:11 +0800
Message-ID: <1507537274-29350-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Hi, Jes;
  The patches mainly fixed the broken raid level conversion against
the commit: 4b74a905a67e
(mdadm/grow: Component size must be larger than chunk size) and one
strncmp issue in mdstat.
  Any suggestions is very welcome.

Thanks very much,
Zhilong

Zhilong Liu (3):
  mdadm/Grow: fix the broken raid level conversion
  mdadm/mdstat: fixup a number of '==' broken formatting
  mdadm/mdstat: correct the strncmp number 4 as 6

 Grow.c   |  3 ++-
 mdstat.c | 39 ++++++++++++++++++++-------------------
 2 files changed, 22 insertions(+), 20 deletions(-)

-- 
2.6.6

