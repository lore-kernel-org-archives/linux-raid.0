From: Luca Berra <bluca@comedia.it>
Subject: Re: 2 HBA's and Multipath.
Date: Thu, 11 Apr 2002 11:49:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020411094959.GE3256@colombina.comedia.it>
References: <20020408190441Z313735-22651+2113@vger.kernel.org> <20020408191622.GB21055@colombina.comedia.it> <20020408200445Z313701-22651+2147@vger.kernel.org>
Reply-To: bluca@comedia.it
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020408200445Z313701-22651+2147@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 08, 2002 at 03:03:00PM -0500, SoulBlazer wrote:
> What about write balancing ?
> 
> I would also be interested in discussing a possible patch to the raid code to 
> do write/read balancing over N hba's if it is that trivial.

the multipath_read_balance routine is actually used both for reading and writing
besides with multipath we don't need to check the head position of the disk
since they are supposed to be the same (if the concept of head position has
any sense with your storage, which i strongly doubt).

what we would need is adding an
int last_used;
to struct multipath_private_data
in include/linux/raid/multipath.h

then rewrite multipath_read_balance in drivers/md/multipath.c
to look something like this.

static int multipath_read_balance (multipath_conf_t *conf)
{
    int disk;

    for (disk = conf->last_used + 1; disk != conf->last_used; disk++) {
	if (disk > conf->raid_disks)
	    disk = 0;
        if (conf->multipaths[disk].operational)
	    return disk;
	}
    BUG();
    return 0;
}

that's all folks, unless i did some very big fuck-up in the code


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
