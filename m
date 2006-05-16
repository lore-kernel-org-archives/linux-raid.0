From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 001 of 3] md: Change md/bitmap file handling to use bmap
 to file blocks-fix
Date: Mon, 15 May 2006 18:54:40 -0700
Message-ID: <20060515185440.0989a805.akpm@osdl.org>
References: <20060516111036.2649.patches@notabene>
	<1060516011302.2711@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060516011302.2711@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, reuben-lkml@reub.net
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
>  +		do_sync_file_range(file, 0, LLONG_MAX,
>  +				   SYNC_FILE_RANGE_WRITE |
>  +				   SYNC_FILE_RANGE_WAIT_AFTER);

That needs a SYNC_FILE_RANGE_WAIT_BEFORE too.  Otherwise any dirty,
under-writeback pages will remain dirty.  I'll make that change.
