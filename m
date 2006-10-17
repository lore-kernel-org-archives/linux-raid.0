From: Greg Dickie <greg@max-t.com>
Subject: Re: PERC5 - MegaRaid-SAS problems..
Date: Tue, 17 Oct 2006 14:13:09 -0400
Message-ID: <1161108789.5880.190.camel@edinburgh.max-t.internal>
References: <Pine.LNX.4.56.0610121246400.11816@lion.drogon.net>
	 <Pine.LNX.4.56.0610171138400.4600@lion.drogon.net>
	 <df1ef2450610171058i15ad6b47kb8579fc3f1a7e8ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <df1ef2450610171058i15ad6b47kb8579fc3f1a7e8ee@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Moise <chops@demiurgestudios.com>
Cc: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org, linux-poweredge@dell.com
List-Id: linux-raid.ids


Never lost an XFS filesystem completely. Can't say the same about ext3.

just my 2 cents,
Greg

On Tue, 2006-10-17 at 13:58 -0400, Andrew Moise wrote:
> On 10/17/06, Gordon Henderson <gordon@drogon.net> wrote:
> > Anyway, it's currently in a RAID-1 configuration (which I used for some
> > initial soaktests) and seems to be just fine:
> >
> > Filesystem            Size  Used Avail Use% Mounted on
> > /dev/md9              6.8T   33M  6.7T   1% /mnt
> 
>   Incidentally, what filesystem are you using?  We may be setting up a
> similar situation soon, and I'm considering ext3 and XFS.  ext3
> apparently has a low max fs size, though, and I've heard bad things
> about XFS's behavior on unclean shutdowns...
> 
> _______________________________________________
> Linux-PowerEdge mailing list
> Linux-PowerEdge@dell.com
> http://lists.us.dell.com/mailman/listinfo/linux-poweredge
> Please read the FAQ at http://lists.us.dell.com/faq
-- 
Greg Dickie
just a guy
Maximum Throughput

