From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: RE: Help raid10 recovery from 2 disks removed
Date: Thu, 24 Oct 2013 14:44:14 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310241441280.1838@uplift.swm.pp.se>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net> <alpine.DEB.2.02.1310241050290.1838@uplift.swm.pp.se> <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net>
Sender: linux-raid-owner@vger.kernel.org
To: yuji_touya@yokogawa-digital.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 24 Oct 2013, yuji_touya@yokogawa-digital.com wrote:

> Here's syslog entries about raid10 and smartctl output.
> sdb seems to have too many bad blocks. Is that the reason why sdb was kicked out?

Most likely.

> I'm going to copy files from /dev/md0 to anywhere else as soon as possible.
> Should I repair filesystem before copying? (like xfs_repair /dev/md0)

What you need to do now is to use dd_rescue or equivalent to copy the data 
off of sdb to a good drive. Stop the array first. This means you'll lose 
data on the bad blocks. After this is done, and you have assembled the 
array with the good drive with (most of) the data from sdb, start the 
array, then hot-add in sdc and let things sync up. You should now have 
redundancy.

Also check why you didn't get notification that sdc wasn't part of the 
array, usually mdmon or equivalent will send email about these events.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
