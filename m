From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCHSET block#for-2.6.36-post] block: convert to REQ_FLUSH/FUA
Date: Mon, 23 Aug 2010 18:47:09 +0200
Message-ID: <20100823164709.GA31221@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1281977523-19335-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phillipp and Lars,

can you look at the changes in

	http://www.spinics.net/lists/linux-fsdevel/msg35884.html

and

	http://www.spinics.net/lists/linux-fsdevel/msg36001.html

and see how drbd can be adapted to it?  It's one of two drivers still
missing, and because it's not quite intuitive what it's doing it's
very hard for Tejun and me to help.
