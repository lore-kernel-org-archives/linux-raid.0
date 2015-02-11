From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] RFC: Use /dev/md/X as default name
Date: Wed, 11 Feb 2015 14:53:08 -0500
Message-ID: <1423684389-10977-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

I have received some issues for when creating an array using a
/dev/mdX name, the matching symlink in /dev/md/X isn't
created. Whereas if you create /dev/md/X, /dev/mdX is created
automatically.

I was trying to see if there was a better way of dealing with this,
but I couldn't find one. If you have suggestions for a better solution
I am all ears.

Thoughts?

Jes

Jes Sorensen (1):
  mddev_create(): choose /dev/md/ name over /dev/mdX

 mdopen.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.1.0

