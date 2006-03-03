From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Fri, 3 Mar 2006 14:39:52 +0100
Message-ID: <20060303133952.GA2976@redhat.com>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <du6t39$be5$1@sea.gmane.org>
Reply-To: mauelshagen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <du6t39$be5$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The fact that mirrors in a RAID1 set partially differ even on propper
shutdown is caused by the ability to change dirty pages *while* they
are being accessed (ie. by a mirroring driver).
This has been a fact in Linux since ever and is expected behaviour with
eg. filesystems, direct IO and memory mapped files.

Mind you that this is a block level inconsistency only, because the
fs/application will always write before it'll read the blocks in
question unless it is not well-behanved.

An example for a filesystem causing this is a file write followed
by a file truncation.

Regards,
Heinz    -- The LVM Guy --

On Thu, Mar 02, 2006 at 02:48:25PM +0100, Mario 'BitKoenig' Holbe wrote:
> Kasper Dupont <48755289462761382922@expires.02.sep.2006.kasperd.net> wrote:
> > A bit too aggressive it seems. How can it end up being marked
> > clean when the two mirrors differ?
> 
> Do you have write-cache enabled on the mirrors?
> 
> Sometimes I have differences between RAID1 mirrors in 2.4, too. Even with
> clean shutdown or reboot sequences. However, in my case, it turns out
> that this always affects areas which are "free" on the filesystem layer.
> This assumption is especially feeded by
> a) the fact that the content of at least one of these differing areas is
> typically zeroed and
> b) that I have md5sums of all my files which don't show up any
> differences when I either copy the non-zero content over the zeros or the
> other way around.
> Especially I have never experienced such "normal" differences on my swap
> RAID1 mirrors. Until now I thought this would have to do with kernel 2.4
> and block-device-specific dirty-page-flushing and missing write-barriers
> and things like that which lead to blocks used for a short time only get
> flushed to the one mirror but not to the other (and then, since they are
> freed again, the flush to the other mirror will never happen, since the
> associated pages are just not dirty anymore).
> However, I thought - at least until now ;) - this would change with 2.6,
> since there md has more control over the block-devices it uses.
> 
> 
> regards
>    Mario
> -- 
> The question of whether a computer can think is no more interesting than
> the question of whether a submarine can swim.          -- E. W. Dijkstra
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
