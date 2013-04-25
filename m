From: Jes.Sorensen@redhat.com
Subject: [PATCH v2 0/1] Quiet down automated tool checking noise
Date: Thu, 25 Apr 2013 17:24:35 +0200
Message-ID: <1366903476-30039-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

As promised, here is the updated patch to add the missing options to
the --help output of mdmon.

Cheers,
Jes


Jes Sorensen (1):
  mdmon: Add missing option documentation to --help output

 mdmon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.8.1.4

