From: "Jonathan Baker-Bates" <jonathan@bakerbates.com>
Subject: The right way to recover from md partition failure?
Date: Mon, 30 Aug 2004 20:38:36 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBJAGHALMCJCFDHBILAEPBENAA.jonathan@bakerbates.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been reading various FAQs and HOWTOs, but for some reason can't really
get an answer to what I assume is a simple question about how best to get a
failed md RAID 1 partition back into an array.

After a power-outage, I see that cat /proc/mdstat shows:

Personalities : [raid1]
read_ahead 1024 sectors
Event: 3
md1 : active raid1 hdg3[1]
      178787264 blocks [2/1] [_U]

md0 : active raid1 hde2[0] hdg2[1]
      2048192 blocks [2/2] [UU]

md2 : active raid1 hde1[0] hdg1[1]
      104320 blocks [2/2] [UU]

unused devices: <none>

So it looks like /dev/hde3 is down. I'm not sure exactly why this is, but
there were some console messages about a bad block or something. So,
assuming hdg3 is OK (which it seems to be) can I just do the following?

Copy good partition to bad one:

dd if=/dev/hdg3 of=/dev/hde3

Add the resulting copy to the raid:

raidhotadd /dev/md1 /dev/hde3

fsck /dev/md1 to make sure all is well.

Is there a better way?

Jonathan






