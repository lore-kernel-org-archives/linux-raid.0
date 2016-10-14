From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: "bitmap" line in /proc/mdstat
Date: Fri, 14 Oct 2016 16:10:00 +0200
Message-ID: <20161014141000.GA23227@metamorpher.de>
References: <5800AE09.70608@bluewin.ch>
 <8922e2e1-b612-fa32-6932-9f4158f52fe6@turmel.org>
 <5800D045.9060602@bluewin.ch>
 <5800E4B8.9040205@bluewin.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5800E4B8.9040205@bluewin.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 14, 2016 at 03:59:20PM +0200, Ramon Hofer wrote:
> Still I would imagine if I assume that a bit per chunck is needed and I 
> use 128kB chuncks on the 11720662272 blocks of the 12TB RAID5 this is:
> log(11720662272)/log(2) = 34 Bytes
> 
> Or am I totally wrong?

It's negligible, a few bytes in the metadata somewhere.

The bitmap has its own size (--bitmap-chunk option). It's fine to set 
this to a large value (128MiB, 1GiB, ...). That might help performance 
and reduce the bytes required for the bitmap itself (not that it matters).

The main issue is performance impact... it's a tradeoff for additional 
bitmap updates each write, or long resync time after a power loss or 
similar event.

If performance is not critical (e.g. it's a NAS, not a database) 
then you can enable it without worries.

Regards
Andreas Klauer
