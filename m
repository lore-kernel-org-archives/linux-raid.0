From: "TJ Harrell" <systemloc@earthlink.net>
Subject: Re: Raid 5: Lossless music archive server recommendations
Date: Tue, 1 Jun 2004 21:53:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001601c44844$617cee90$0201a8c0@windows>
References: <002501c44837$64699a20$0201a8c0@windows>    <20040602012500.12304.qmail@web61004.mail.yahoo.com> <1433.153.90.196.102.1086140077.squirrel@web1.cs.montana.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: admin@cs.montana.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I have a system that uses drives on all channels, eg master/slave.
> and I have encountered any slowdown, by using primary and secondary disks
> in the same channel.
> Yes it is slower, but for me performance is good enough.

With two drives per channel, doesn't a disk failure pull down the other
drive, causing the entire array to fail, and require a reboot to bring the
degraded array back online?


