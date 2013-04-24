From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] Quiet down automated tool checking noise
Date: Wed, 24 Apr 2013 17:00:15 +0200
Message-ID: <1366815616-28045-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Had an automated tool checking the help page moan that -a wasn't
documented in the --help output, so lets just add that and keep the
noise down :)

Cheers,
Jes



Jes Sorensen (1):
  mdmon: Document that -a is equivalent to --all in --help output

 mdmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.8.1.4

