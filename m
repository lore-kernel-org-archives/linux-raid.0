From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch 6/7] blk: add plug for blkdev_issue_discard
Date: Tue, 13 Mar 2012 11:51:20 -0400
Message-ID: <20120313155120.GG29169@redhat.com>
References: <20120312030412.375458948@fusionio.com>
 <20120312031305.946211513@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120312031305.946211513@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

On Mon, Mar 12, 2012 at 11:04:18AM +0800, Shaohua Li wrote:
> In raid 0 case, a big discard request is divided into several small requests
> in chunk_size unit. Such requests can be merged in low layer if we have
> correct plug added. This should improve the performance a little bit.

Martin posted a patch to remove the support for allowing merging of discard
requests. But this seems to be a reasonable use case for allowing mering
discard requests. CCing Martin.

Thanks
Vivek
