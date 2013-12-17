From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID 6 reads all remaining chunks in a stripe when a single chunk
 is rewritten
Date: Tue, 17 Dec 2013 13:51:32 +0000
Message-ID: <21168.22244.972559.113671@tree.ty.sabi.co.uk>
References: <52B02A08.4090007@informatik.uni-rostock.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52B02A08.4090007@informatik.uni-rostock.de>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ] RAID 6 [ ... ] It seems like that in the event of
> updating one data chunk in a stripe, all of the remaining data
> chunks are read. [ ... ]

http://www.mail-archive.com/jfs-discussion@lists.sourceforge.net/msg01707.html
