From: mjstumpf <mjstumpf@cotse.net>
Subject: monitoring means for IBM ServeRAID driver?
Date: Mon, 30 Jun 2003 12:15:08 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bWpzdHVtcGY=.f03bfc26e5230960f5f182cfeb610c52@1056989708.cotse.net>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Didn't see anything in the archives.

Is there some "trivial" means ("cat /proc/mdstat" or its equivalent in
mdadm) of monitoring the health of a raid constructed via IBM ServeRAID? 
The RAID appears to linux as a opaque, very large scsi device.

"cat /proc/scsi/ips/1" only shows me uninteresting info.. firmware level,
etc.  Everything is working fine right now, but I have a bad feeling that
a drive could die & I won't even know it.

I've seen reference to some sort of RAS / device driver hardening on the
IBM OSS website, but no details.. just patch files.

Thanks in advance,
Michael Stumpf




