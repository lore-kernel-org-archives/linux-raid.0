From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/8] block/genhd.c: Add error handling
Date: Tue, 10 Nov 2015 03:33:22 +0000
Message-ID: <20151110033322.GB22011@ZenIV.linux.org.uk>
References: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
 <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
Sender: linux-ide-owner@vger.kernel.org
To: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jmoyer@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, davem@davemloft.net, neilb@suse.com, ulf.hansson@linaro.org, tiwai@suse.de, hare@suse.de, ming.lei@canonical.com, jarod@redhat.com, tj@kernel.org, adrian.hunter@intel.com, jonathanh@nvidia.com, grundler@chromium.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, cpgs@samsung.com, vishu13285@gmail.com, pintu.k@samsung.com, rohit.kr@samsung.com
List-Id: linux-raid.ids

On Fri, Nov 06, 2015 at 05:52:08PM +0530, Vishnu Pratap Singh wrote:

Have you even tried to trigger the failure exits you've added?  The
more you've successfully set up, the _less_ your cleanup code ends
up undoing; that simply can't be right.

That aside, as soon as we'd done register_disk(), the damn thing is
available for open(), so bailing out is _really_ not something for
faint-hearted - it's essentially equivalent to removal of device under
somebody who'd opened it and might've started IO, etc.  Going there
simply because some sysfs shite didn't get created doesn't look sane
as far as I'm concerned...

Especially since these failure exits are not going to be tested on
a regular basis, so the amount of bitrot will be pretty high ;-/
