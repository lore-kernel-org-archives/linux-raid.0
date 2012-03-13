From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 6/7] blk: add plug for blkdev_issue_discard
Date: Tue, 13 Mar 2012 13:19:15 -0400
Message-ID: <yq1mx7ka06k.fsf@sermon.lab.mkp.net>
References: <20120312030412.375458948@fusionio.com>
	<20120312031305.946211513@fusionio.com>
	<20120313155120.GG29169@redhat.com>
	<yq1vcm8a0ud.fsf@sermon.lab.mkp.net>
	<20120313171414.GJ29169@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120313171414.GJ29169@redhat.com> (Vivek Goyal's message of
	"Tue, 13 Mar 2012 13:14:14 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Shaohua Li <shli@fusionio.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> So first we will get rid of mering discard request 

We'll get rid of code that doesn't do anything other than confuse.


Vivek> and then enable after one release cycle once REQ_COPY support is
Vivek> in?

The new code will be entirely different. And one cycle is optimistic
given the current state of affairs in T10.

-- 
Martin K. Petersen	Oracle Linux Engineering
