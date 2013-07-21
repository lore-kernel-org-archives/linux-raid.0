From: mwilck@arcor.de
Subject: [RFC/PATCH 0/6] DDF: safe big-endian types
Date: Sun, 21 Jul 2013 19:28:18 +0200
Message-ID: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Hi Neil, hello list,

please review this patch series. I made so many endianness bugs
while working on DDF during the last months that I thought this
might be helpful - it will cause bugs to be caught by the
compiler which may otherwise turn up as hard-to-find runtime errors.

Note that the code  *does not* compile after each patch, only 
after the last one. I broke it down to make it more readable.

Patch 0005 and 0006 are separate because they are actual minor bugs
in the code that the endianness patch set helped me find.

I verified that the DDF unit tests aren't broken by this patch set.

Martin

Martin Wilck (6):
  DDF: add endian-safe typedefs
  DDF: convert big endian to be32 type
  DDF: convert big-endian __u64 to be64 type
  DDF: convert big-endian __u16 to be16 type
  DDF: add_other_bvd: fix endianness bug
  DDF: ddf_set_disk: fix minor endianness bug

 super-ddf.c |  851 ++++++++++++++++++++++++++++++++---------------------------
 1 files changed, 462 insertions(+), 389 deletions(-)
