From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 001 of 3] md: Change md/bitmap file handling to use bmap
 to file blocks-fix
Date: Tue, 16 May 2006 12:16:16 +1000
Message-ID: <17513.13808.915295.711470@cse.unsw.edu.au>
References: <20060516111036.2649.patches@notabene>
	<1060516011302.2711@suse.de>
	<20060515185440.0989a805.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Monday May 15
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, reuben-lkml@reub.net
List-Id: linux-raid.ids

On Monday May 15, akpm@osdl.org wrote:
> NeilBrown <neilb@suse.de> wrote:
> >
> >  +		do_sync_file_range(file, 0, LLONG_MAX,
> >  +				   SYNC_FILE_RANGE_WRITE |
> >  +				   SYNC_FILE_RANGE_WAIT_AFTER);
> 
> That needs a SYNC_FILE_RANGE_WAIT_BEFORE too.  Otherwise any dirty,
> under-writeback pages will remain dirty.  I'll make that change.

Ahhh.. yes... that makes sense!  Thanks :-)

NeilBrown
