From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH/BUG] mdadm: write behind value does not have endian conversion
Date: Mon, 9 Oct 2006 11:20:05 +1000
Message-ID: <17705.41925.757418.540579@cse.unsw.edu.au>
References: <45269835.2020801@steeleye.com>
	<4526A88E.9000005@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Friday October 6
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 6, paul.clements@steeleye.com wrote:
> Paul Clements wrote:
> 
> > --- mdadm-2.5.1/bitmap.c.orig	Fri Oct  6 13:40:35 2006
> > +++ mdadm-2.5.1/bitmap.c	Fri Oct  6 13:40:53 2006
> > @@ -33,6 +33,7 @@ inline void sb_le_to_cpu(bitmap_super_t 
> >  	sb->chunksize = __le32_to_cpu(sb->chunksize);
> >  	sb->daemon_sleep = __le32_to_cpu(sb->daemon_sleep);
> >  	sb->sync_size = __le64_to_cpu(sb->sync_size);
> 
> > +	sb->write_behind = __le32_to_cpu(sb->sync_size);
> 
> Obviously, sync_size should be write_behind in the above line.

Thanks.  
Applied and push out to git.

NeilBrown
