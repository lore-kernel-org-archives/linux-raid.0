From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] kernfs: handle poll correctly on 'direct_read' files.
Date: Mon, 16 Mar 2015 12:30:14 -0400
Message-ID: <20150316163014.GA8353@htj.duckdns.org>
References: <20150316104452.366bffc0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150316104452.366bffc0@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Prakash Punnoor <prakash@punnoor.de>, Torsten Kaiser <just.for.lkml@googlemail.com>, linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 16, 2015 at 10:44:52AM +1100, NeilBrown wrote:
> 
> 
> Kernfs supports two styles of read: direct_read and seqfile_read.
> 
> The latter supports 'poll' correctly thanks to the update of
> '->event' in kernfs_seq_show.
> The former does not as '->event' is never updated on a read.
> 
> So add an appropriate update in kernfs_file_direct_read().
> 
> This was noticed because some 'md' sysfs attributes were
> recently changed to use direct reads.
> 
> Reported-by: Prakash Punnoor <prakash@punnoor.de>
> Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> Fixes: 750f199ee8b578062341e6ddfe36c59ac8ff2dcb

This fixes tag is kinda weird without further explanation.

> Signed-off-by: NeilBrown <neilb@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
