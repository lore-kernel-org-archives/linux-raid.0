From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: RE: raid1 boots with one disk only
Date: Fri, 4 Mar 2005 16:05:46 -0500
Message-ID: <2263802DEDF02046B82EB18DE91725ED17A3E7@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-raid-owner@vger.kernel.org
To: 'Steve Kwee' <skwee@itw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think you need to tweak your kernel lines in /boot/grub/menu.lst to
include the following clause:

	md=1,/dev/sda2,/dev/sdc2

...assuming I didn't misinterpret your configuration information. :-) You
should be able to append this right onto the end of the existing options.
This tells the RAID module explicitly to assemble device /dev/md1 from the
listed physical devices.

This works fine for me on an x86 system at home and an alpha system at work.
:-)

Cheers,

	Scott
