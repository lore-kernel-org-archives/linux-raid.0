From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Hi! Why having LSR's chunk size 2^n limitation?
Date: Tue, 18 Jan 2011 22:59:07 +0700
Message-ID: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

   I had experience of using FreeBSD's vinum (another software RAID).
Its author, Greg Lehey, stated in vinum's manual: "... A good
guideline for stripe size is between 256 kB and 512 kB.  Avoid powers
of 2, however: they tend to cause all superblocks to be placed on the
first subdisk. ..."

   Meanwhile, with LSR we're given exactly 2^n choices, for e. g.,
neither 768 KiB, nor 387 KiB won't go: "mdadm: invalid chunk/rounding
value: 387".

   So, why... ($Subj) and how complex would it be to abolish this
restriction? I think this could be a key to performance increase.

   P. S. Thanks a ton for LSR, Neil, BTW. :-)

-- 
End of message. Next message?
