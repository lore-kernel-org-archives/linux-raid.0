From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Monitoring for failed drives
Date: Thu, 3 May 2012 10:06:18 +0100
Message-ID: <20120503090618.GB3262@nsrc.org>
References: <20120425123951.GB10172@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120425123951.GB10172@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 25, 2012 at 01:39:51PM +0100, Brian Candler wrote:
> OK, so that's fairly obviously a failed drive.
> 
> The problem is, how to detect and report this?

More specifically, is there a kernel counter I can look at, perhaps
something under /sys, which counts the number of I/O errors when accessing a
block device?  (Recovered and non-recovered?)

Or is the only way to find this sort of error through parsing syslog
messages?

I did find this:

    $ cat /sys/block/sda/stat
      134257    51671 11141686  1337160 60502372 124014063 1476148888 1325166568 0 137287732 1326384944

However there don't seem to be error counters in there. According to
http://www.kernel.org/doc/Documentation/block/stat.txt

    Name            units         description
    ----            -----         -----------
    read I/Os       requests      number of read I/Os processed
    read merges     requests      number of read I/Os merged with in-queue I/O
    read sectors    sectors       number of sectors read
    read ticks      milliseconds  total wait time for read requests
    write I/Os      requests      number of write I/Os processed
    write merges    requests      number of write I/Os merged with in-queue I/O
    write sectors   sectors       number of sectors written
    write ticks     milliseconds  total wait time for write requests
    in_flight       requests      number of I/Os currently in flight
    io_ticks        milliseconds  total time this block device has been active
    time_in_queue   milliseconds  total wait time for all requests

I also found UCD-DISKIO-MIB in net-snmp, but it doesn't have error counters
either:

    diskIOEntry OBJECT-TYPE
        SYNTAX      DiskIOEntry
        MAX-ACCESS  not-accessible
        STATUS      current
        DESCRIPTION
            "An entry containing a device and its statistics."
        INDEX       { diskIOIndex }
        ::= { diskIOTable 1 }

    DiskIOEntry ::= SEQUENCE {
        diskIOIndex         Integer32,
        diskIODevice        DisplayString,
        diskIONRead         Counter32,
        diskIONWritten      Counter32,
        diskIOReads         Counter32,
        diskIOWrites        Counter32,
        diskIONReadX        Counter64,
        diskIONWrittenX     Counter64
    }

Is there anywhere else I should look for this?

Thanks,

Brian.
