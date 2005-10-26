From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: split RAID1 during backups?
Date: Wed, 26 Oct 2005 11:15:11 -0700
Message-ID: <1130350511.6339.88.camel@seki.nac.uci.edu>
References: <Pine.LNX.4.44.0510251550250.28299-100000@firewall2.tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0510251550250.28299-100000@firewall2.tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: davidsen@tmr.com
Cc: Jeff Breidenbach <jeff@jab.org>, linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


I noticed some discussion of both netcat and NBD in this thread, and
these are both things I've investigated at various points during the
last 365.25 days.  :)


On the subject of netcat:

        You might be interested in my pnetcat program at
        http://dcs.nac.uci.edu/~strombrg/pnetcat.html .  It's similar to
        netcat, but perhaps behaves itself better with regard to EOF's,
        can read/write to/from sockets/stdin/stdout arbitrarily (EG,
        both to and from two different sockets, or to and from stdout
        and stdin), like netcat it can also do TCP and UDP (but UDP is
        without any form of error detection - not sure where this is in
        netcat), is at least in some cases faster due to use of large
        blocksizes and adjustable TCP windows, and it's written in a
        VHLL making it ultra-easy to read and maintain.


On the subject of NBD:

        ENBD is supposed to be a funded, improved version of NBD.  Last
        I checked, there was a version of NBD in the Linus kernels, but
        ENBD was still distributed as patches.  GNBD, which I haven't
        examined in isolation (although I have done some GFS overtop of
        GNBD, which didn't work out that well - GFS was pitched to us by
        IBM but didn't work out - it wouldn't do what we needed even on
        the GFS -roadmap-) may or may not be more reliable than ENBD.
        
        My NBD/ENBD notes: http://dcs.nac.uci.edu/~strombrg/nbd.html
        
        If someone experiments with GNBD for getting > 2T filesystems,
        or better still, > 16T filesystems, -without- GFS overtop of it
        (EG, putting an XFS or JFS or ReiserFS overtop of a large device
        tacked together with MD or LVM or LVM2 or EVMS) I'd very much
        like to hear about that!


