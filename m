From: Luca Berra <bluca@comedia.it>
Subject: Re: Can't boot from /dev/md0 (RAID-1) (more info)
Date: Sun, 30 Jun 2002 20:42:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020630184207.GA1179@colombina.comedia.it>
References: <200206301922.44157.roy@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200206301922.44157.roy@karlsbakk.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 30, 2002 at 07:22:44PM +0200, Roy Sigurd Karlsbakk wrote:
> see below for my original post
> 
> I've uploaded some files to http://karlsbakk.net/bugs/ that may help to
> explain the problem. Still - I can't boot from nothing but floppy.
> 
> thanks
> 
uhm,
some versions of lilo used to write to the mbr when told boot=/dev/md?
others to the first sector of the container partition.

you better put a standard mbr on the disk and mark as active the partitions
that are part of md0

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
