From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Re: Real Time Mirroring of a NAS
Date: Fri, 7 Apr 2006 20:04:18 +0400
Message-ID: <8110058661.20060407200418@2ka.mipt.ru>
References: <44364336.7060704@aol.com>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44364336.7060704@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello andy,

al> Can I export NAS B as a SAN or ISCSI target, connect the two machines
Am I right in the assumption that your NASes are Linux boxes? :)

Did you take a look at Linux "Network block devices" (nbd/enbd)? They
might be what you need: you'd get a raw device on one of the servers
to use in a mirror along with a local device. The NBD page mentioned
some setups for high-availability services where an active server
clones itself to a backup server and vice-versa, whichever was active
most recently.

I'm not sure about performance though...

al> with, say, mryinet cards or 10 GbE TOE cards, mount the NAS B volume on
al> NAS A, and create a RAID-1 mirror of the two volumes? Is this kind of
al> thing done?

Are you sure you need 10GbE? My experience with a 10-drive 3Ware 8506
array in RAID5 shows that reads from it usually fit in 500-700Mbit/s.
And it's a very busy popular fileserver, so I guess it's close to the
hardware limits of our array.

-- 
Best regards,
 Jim Klimov                            mailto:klimov@2ka.mipt.ru

