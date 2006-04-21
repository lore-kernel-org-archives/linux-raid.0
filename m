From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: too small chunk_size: 4096 < 8192
Date: Fri, 21 Apr 2006 13:04:23 -0400
Message-ID: <F3598542BAC24B4783B7A440D45522FF04050536@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I guess this is what I get for thinking that chunk size didn't matter
for RAID1 arrays when I set up a few of them a couple years back on my
Alphaserver running Debian Linux... And then choosing or defaulting
(don't recall which) an absurdly small value. :-)

A recent attempt at switching from my 2.6.15 kernel to a newer 2.6.16
kernel resulted in the above error when attempting to assemble /dev/md1,
which is my root filesystem.

Looking at the source trees for 2.6.15 and 2.6.16 shows the test hasn't
changed, so I conclude that my immediate problem is that the new kernel
has decided I would be better off with 8KB pages rather than 4KB pages.
Whatever.

Since I'm using RAID1, for which chunk_size reputedly is a meaningless
quantity, what I'd really like to do is change that on my existing
arrays to something else (64KB?) and just carry on. However, the mdadm
v1.12.0 I have from Debian provides no mechanism for doing that, and I
don't recall discussion of this functionality being added to any of the
newer mdadm releases either.

Does anybody have a clever suggestion, or do I grit my teeth and
CAREFULLY recreate my arrays while trying not to destroy any of the
encapsulated data?

Thanks,

	Scott Bailey
	scott.bailey@eds.com
