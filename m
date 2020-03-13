From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 02/21] block: remove __bdevname
Date: Fri, 13 Mar 2020 10:19:38 -0400
Message-ID: <20200313141938.GD225435@mit.edu>
References: <20200312151939.645254-1-hch@lst.de>
 <20200312151939.645254-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200312151939.645254-3-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 12, 2020 at 04:19:20PM +0100, Christoph Hellwig wrote:
> There is no good reason for __bdevname to exist.  Just open code
> printing the string in the callers.  For three of them the format
> string can be trivially merged into existing printk statements,
> and in init/do_mounts.c we can at least do the scnprintf once at
> the start of the function, and unconditional of CONFIG_BLOCK to
> make the output for tiny configfs a little more helpful.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Theodore Ts'o <tytso@mit.edu> # for ext4
