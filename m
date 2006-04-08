From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Raid 4 idea!
Date: Sat, 8 Apr 2006 08:44:39 +0200
Message-ID: <005901c65ad7$ea45f6c0$2c00a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list,

I have one idea!

I using raid4, and found to be really good, but i think this can be more
better! :-)

If the raid4 fails one disk (except the patiry disk), the md currently only
drop the disk from array, but i think this could be more useful, if the md
immediately starts to transform the parity disk into the place fo missing
disk!

This is possible, and with this option, performance-dependent systems can go
faster again, after the "rebuild" is completed!

This is only requires one (big) number in superblock to count/track the
process.

Also this has a little risk too, and need to be an "expert" option - i
think...

What do you think, Neil?

Cheers,
Janos

