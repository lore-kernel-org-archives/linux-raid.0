From: aragonx@dcsnow.com
Subject: Re: How to boost performance
Date: Thu, 17 Jun 2010 09:49:42 -0400
Message-ID: <d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
    <20100617100109.32a20ffa@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100617100109.32a20ffa@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: aragonx@dcsnow.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Wed, 16 Jun 2010 18:23:36 -0400
> Increasing stripe cache size from the default of 256 should help
> immensely.
>
> echo 16384 > /sys/block/md0/md/stripe_cache_size
>
> Be warned that this consumes (^that amount * 4096 * number of disks) bytes
> of
> RAM. Some benchmarks:

Hello.  Thank you for the quick suggestions!

First I need to correct myself.  I only have the slowdown when writing to
the server.  Reads from the server are usually in the 60-70MB/sec range
regardless of file size.

Prior to the change above, on a 2GB file, I would start off the write (to
the server) at 70MB/sec and end at about 35MB/sec.  CPU usage was at 100%
with the md0 using about 70% CPU and smb using 30% with flush sometimes
jumping in at 30%.  Wait states remained below 10%.  After the change, on
a 2GB file I would start the write at 70MB/sec and end about 55MB/sec
(nice improvement!).

Switched to a 5GB file and the write ended around 35MB/sec.  At the
beginning smbd would star with 50% CPU but gradually go down to 30% with
md0 ramping up to 70% and flush jumping in from time to time at 30%.

This information is all coming from top.  If I should use something else
that will get more accurate readings, please let me know.

With one change my performance greatly increased but I would like to see
more.  Is there anything else I can do?  I'm hoping to get sustainable
60MB/sec writes.  Is that possible?

Thank you if you have read this far!  :)

---
Will Y.


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

