From: Neil Brown <neilb@suse.de>
Subject: Re: [PULL REQUEST] 2 (or 3) bug fixes for drives/md in 2.6.29
Date: Fri, 6 Feb 2009 18:05:13 +1100
Message-ID: <18827.57641.200482.849596@notabene.brown>
References: <18827.47741.271010.507719@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757136AbZBFHFg@vger.kernel.org>
In-Reply-To: message from Neil Brown on Friday February 6
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

On Friday February 6, neilb@suse.de wrote:
> 
> Two small patches for md.
> The first is marked for -stable.

Make that three patches - I just found another bug (or maybe a missing
but very important feature).  It is for -stable too.

Thanks,
NeilBrown

The following changes since commit eda58a85ec3fc05855a26654d97a2b53f0e715b9:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../cooloney/blackfin-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Andre Noll (1):
      md: Fix a bug in linear.c causing which_dev() to return the wrong device.

NeilBrown (2):
      md: Allow read error in a single drive raid1 to be passed up.
      md: Ensure an md array never has too many devices.

 drivers/md/linear.c |    6 +++---
 drivers/md/md.c     |   24 ++++++++++++++----------
 drivers/md/raid1.c  |    3 ++-
 3 files changed, 19 insertions(+), 14 deletions(-)
