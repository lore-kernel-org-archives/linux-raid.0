From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH] md: stop using do_sync_mapping_range
Date: Wed, 23 Sep 2009 14:47:15 +0100
Message-ID: <20090923134715.GA15256@shareable.org>
References: <20090923131822.GA12287@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090923131822.GA12287@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Christoph Hellwig wrote:
> -		do_sync_mapping_range(file->f_mapping, 0, LLONG_MAX,
> -				      SYNC_FILE_RANGE_WAIT_BEFORE |
> -				      SYNC_FILE_RANGE_WRITE |
> -				      SYNC_FILE_RANGE_WAIT_AFTER);
> +		filemap_write_and_wait(file->f_mapping);
>
> It's a very awkward way to write out all data and wait for it, so just
> call filemap_write_and_wait.  I still can't figure what the point of
> all this is, so a comment would surely be helpful.

The SYNC_FILE_RANGE_WAIT_BEFORE is to make sure that writes which were
started before the most recent dirtying are completed before
initiating a second write on the same pages to make sure the most
recently dirty data is written.

Does filemap_write_and_wait() do that?

Fwiw, It's partially redundant: it isn't necessary to have a second
write when the first write request was queued in the elevator but
hadn't yet reached the device.

-- Jamie
