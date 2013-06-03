From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RAID-10 keeps aborting
Date: Sun, 02 Jun 2013 20:57:52 -0700
Message-ID: <51AC1440.7020505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a brand new server with a RAID-10 array.  The drives are a SAS
JBOD (mptsas) which I'm driving using Linux mdraid raid10.

Unfortunately, although the server did burn-in fine, once put in
production I have so far had multiple cases (about once every 24 hours)
of the raid10 failing, with a mirror pair dropping out in very short
succession:

Jun  2 20:23:05 terminus kernel: [83595.614689] md/raid10:md4: Disk
failure on sdb6, disabling device.
Jun  2 20:23:05 terminus kernel: [83595.614689] md/raid10:md4: Operation
continuing on 3 devices.
Jun  2 20:23:05 terminus kernel: [83595.703106] md/raid10:md4: Disk
failure on sdc6, disabling device.
Jun  2 20:23:05 terminus kernel: [83595.703106] md/raid10:md4: Operation
continuing on 2 devices.
Jun  2 20:23:05 terminus kernel: [83595.789234] md4: WRITE SAME failed.
Manually zeroing.

Unfortunately, those two devices that just dropped out are of course the
mirrors of each other, causing filesystem corruption and shutdown in
very short order.

There are no other kernel messages from the same time, and given the
timing (less than 90 ms apart) it would appear that this is a timeout of
some kind and not an actual disk failure.

Are there any tunables I can tweak, or do I have a $4000 paperweight?

	-hpa
