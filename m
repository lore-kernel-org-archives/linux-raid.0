From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: RAID5 recovery after disk-change
Date: Wed, 13 Aug 2003 14:04:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F3A7DBA.ECEDB7D8@SteelEye.com>
References: <Pine.LNX.4.44.0308131930450.13687-100000@aifbshark.aifb.uni-karlsruhe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Simon Frettloeh <sifr@aifb.uni-karlsruhe.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Simon Frettloeh wrote:

> So it seems, that hdg1 moved by itself from "4" to "2". What happened
> (according to my previous email)?
> 
> Do I have to do any further things or is my RAID now working fine?

This is normal behavior. When a spare disk is added, it is placed into
the array above the normal disk slots (in your case, slots 4 and up) and
is then resynced. Once resync is complete, the disk is moved into the
first open normal slot (in your case, slot 2) and is then used as part
of the array.

--
Paul
