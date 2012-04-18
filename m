From: Tom Rini <tom.rini@gmail.com>
Subject: Fixing broken metadata?
Date: Wed, 18 Apr 2012 10:22:09 -0700
Message-ID: <CA+M6bXkCQNXJ58mL0uNqu9oBgLhYq+sPWMiyqc+T9o5sVYgFmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey all,

As part of tracking down a bug in mvsas in 3.4-rc3, my raid0 array got
trashed a bit.  Currently mdadm --misc /dev/.. -E gives results like
this: http://pastebin.com/X2kWmF1A is there a backup copy of the
metadata somewhere or some other way to force re-creating the array
and let e2fsck decide if there's anything salvageable?  If not I can
live with re-creating it.  Thanks!

-- 
Tom
