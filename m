From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: How important is SCTERC?
Date: Fri, 28 Apr 2017 14:07:51 +0100
Message-ID: <22787.16039.574815.87299@tree.ty.sabi.co.uk>
References: <48135126-cd8e-6321-77e6-06ae349ecc03@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48135126-cd8e-6321-77e6-06ae349ecc03@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ] I do run tler.sh that sets 180s timeout for drives
> that do not have scterc from /etc/rc.local. Am I putting my
> data in serious danger?

No.

> I only have videos and tv recordings in this md

The problem with SCT/ERC absence is that the 2-3 minutes of
retries suspend IO for that long, and for people running
interactive applications (usually LAMP-style web applications)
that is a bad idea, but in your case you seem to have just a
personal archive of entertainment files.

For interactive "enterprise" applications the common practice is
to reduce the error timeout to 1-2 seconds, so the failing drive
drops out of the MD set quickly and can be replaced, minimizing
delays.

> which can be replaced with significant effort (about 12TB of
> movies and tv shows will take some time to copy from my
> DVDs/BDs)

Backups are very important, and RAID is not an alternative to
backups. You can buy and use SMR disk drives as if they were
tapes (or with a filesystem like NILFS2) to do that backup, and
they are quite cheap.
