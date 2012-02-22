From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] Make failure message on re-add more explcit
Date: Wed, 22 Feb 2012 17:59:59 +0100
Message-ID: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

I have seen this come up on the list a couple of times, and also had
bugs filed over it, since this used to 'work'. Making the printed
error message a little more explicit should hopefully make it clearer
why this is being rejected.

Thoughts?

Cheers,
Jes


Jes Sorensen (1):
  Make error message on failure to --re-add more explicit

 Manage.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

-- 
1.7.4.4

