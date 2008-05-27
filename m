From: Neil Brown <neilb@suse.de>
Subject: Re: aoe disk not recognized as part of raid
Date: Tue, 27 May 2008 16:59:28 +1000
Message-ID: <18491.45392.503390.245024@notabene.brown>
References: <20080523142525.31d6e06b.taeuber@bbaw.de>
	<20080523170056.d6e39787.taeuber@bbaw.de>
	<46144.192.168.1.70.1211610465.squirrel@neil.brown.name>
	<20080526122057.1ed4454e.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lars Tauber on Monday May 26
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 26, taeuber@bbaw.de wrote:
> (gdb) where
> #0  0x000000000040cd72 in Assemble (st=0x0, mddev=0x6364f0 "/dev/md4", mdfd=3, 
>     ident=0x636630, devlist=0x636b90, backup_file=0x0, readonly=0, runstop=0, 
>     update=0x0, homehost=0x0, verbose=0, force=0) at Assemble.c:370
> #1  0x00000000004058a4 in main (argc=2, argv=0x7fff2317c6d8) at mdadm.c:1086
> (gdb) 
> 
> I hope this helps.

Yes it does thanks.  I'll get that fixed.

> 
> Any idea on the actual subject?

I need you to try the --assemble with --verbose to find out what is
happening.
Use an earlier version of mdadm.  (e.g. 2.6.4).

NeilBrown
