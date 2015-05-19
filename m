From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 10/11] md/raid10: make sync_request_write() call
	bio_copy_data()
Date: Tue, 19 May 2015 10:45:51 +0200
Message-ID: <20150519084551.GB374@lst.de>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org> <1430980461-5235-11-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430980461-5235-11-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This seems fine even without the rest of the series.  Jens or Neil,
can you pick this one up?

Reviewed-by: Christoph Hellwig <hch@lst.de>
