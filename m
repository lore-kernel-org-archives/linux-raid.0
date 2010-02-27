From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 0/3] *** fix gcc warnings ***
Date: Sat, 27 Feb 2010 11:14:43 +0100
Message-ID: <cover.1267264723.git.bluca@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

building current git with -O2 -Wall -Werror aborts with compiler warnings
patch 1 fixes a strict-aliasing violation
patch 2 addresses trivial to fix warning
patch 3 is just _WRONG_: there is no clear way to bailout from the functions in
Grow.c, and i have no idea if aborting would leave the array in an inconsistent
state. For the time being I just decided to please gcc by storing the result
somwere, but it is never checked.

L.

Luca Berra (3):
   fix gcc warnings about strict-aliasing rules
   fix compiler warnings
   workaround unused_results

  Grow.c     |   30 +++++++++++++++++++-----------
  mdmon.c    |    2 +-
  restripe.c |    2 +-
  util.c     |    4 ++--
  4 files changed, 23 insertions(+), 15 deletions(-)


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
