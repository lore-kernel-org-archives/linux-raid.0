From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 0/2] *** mdmon fixes ***
Date: Sat, 27 Feb 2010 16:05:40 +0100
Message-ID: <cover.1267282753.git.bluca@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

These close a couple of issues with mdmon.
I don't claim to understand all of the code yet, but a cursory look leaves me
with the feeling that there are multiple ways it could still fail

Luca Berra (2):
   fix mdmon option parsing
   fix mdmon takeover

  mdmon.c |   23 ++++++++++++++++++-----
  msg.c   |    2 +-
  util.c  |    4 ++--
  3 files changed, 21 insertions(+), 8 deletions(-)

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
