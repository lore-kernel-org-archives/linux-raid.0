From: keld@keldix.com
Subject: self healing of MD raid
Date: Tue, 2 Jun 2015 19:22:36 +0200
Message-ID: <20150602172236.GA23446@www5.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list

I wonder if MD RAID software is kind of self healing.
That is, if a read operation gets an IO error, then the logical
sector of the RAID can be recreated from the other sector(s)
of the raid, and then written out on the block which gave a read error.

His could work both for the mirrored RAID types, and for the
parity orientet RAID types.

Is that implemented in MD RAID?

Similarily the self healing process could be part of the monitoring
background processes.

Best regaqrds
keld
