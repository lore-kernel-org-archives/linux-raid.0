From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 6/7] blk: add plug for blkdev_issue_discard
Date: Tue, 13 Mar 2012 13:04:58 -0400
Message-ID: <yq1vcm8a0ud.fsf@sermon.lab.mkp.net>
References: <20120312030412.375458948@fusionio.com>
	<20120312031305.946211513@fusionio.com>
	<20120313155120.GG29169@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120313155120.GG29169@redhat.com> (Vivek Goyal's message of
	"Tue, 13 Mar 2012 11:51:20 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shli@fusionio.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> On Mon, Mar 12, 2012 at 11:04:18AM +0800, Shaohua Li wrote:
>> In raid 0 case, a big discard request is divided into several small
>> requests in chunk_size unit. Such requests can be merged in low layer
>> if we have correct plug added. This should improve the performance a
>> little bit.

Vivek> Martin posted a patch to remove the support for allowing merging
Vivek> of discard requests. But this seems to be a reasonable use case
Vivek> for allowing mering discard requests. CCing Martin.

Merging discard requests is hard given how we need to prepare the
command payload at the bottom of the stack. The current upstream merge
code pretends to be working but it actually doesn't. That's why I want
it dead and buried.

I have some changes pending (that I need for the REQ_COPY support) that
will make merging of non-rw requests easier to deal with. But that's a
kernel release cycle away...

-- 
Martin K. Petersen	Oracle Linux Engineering
