From: linux@horizon.com
Subject: Hardware RAID and DDF metadata
Date: 13 Jan 2004 20:40:36 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040113204036.22672.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a *very* interesting development, and one I heartily
support.

Right now, I strongly advise AGAINST hardware RAID controllers because
they aren't tolerant of failures in a manufacturer's interest in
making replacement controllers.

While with software RAID, I split mirrors across two different IDE
controllers so my array can survive the failure of one of them and I
can just get another generic JBOD IDE controller card.

It actually happened once - although it was fixed by just plugging in
the IDE controller card properly - and it was indeed survived.


(As for an "endian safe" superblock, I don't even know what that means.
ISO-9660 tried requiring bi-endian metadata on the grounds that shifting
work fromn readers to writers made sense in a read-only medium, but a)
that doesn't apply to this case, and b) there are so many buggy writers
now that Linux only uses the little-endian data now, AFAIK.

Given that experience, one tool that should be written by the standards
group is a metadata validator that is verbose and picky in the extreme.

Just use a defined, and consistent, endianness, and I don't care which.
Making it properly aligned so it can be used as an in-core format as
well after byte-swapping would be a win, but not essential.)
