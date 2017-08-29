From: Ming Lei <ming.lei@redhat.com>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Tue, 29 Aug 2017 08:24:25 +0800
Message-ID: <20170829002425.GA28904@ming.t460p>
References: <3926917.BCSovyVWdL@natalenko.name>
 <4174287.OjL0pO8MRx@natalenko.name>
 <20170828125822.GA19670@ming.t460p>
 <1615033.Xza1AIGLzP@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1615033.Xza1AIGLzP@natalenko.name>
Sender: linux-raid-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 28, 2017 at 08:22:26PM +0200, Oleksandr Natalenko wrote:
> Hi.
> 
> On pondělí 28. srpna 2017 14:58:28 CEST Ming Lei wrote:
> > Could you verify if the following patch fixes your issue?
> > …SNIP…
> 
> I've applied it to v4.12.9 and rechecked — the issue is still there, 
> unfortunately. Stacktrace is the same as before.
> 
> Were you able to reproduce it in a VM?

Yes, I can.

> 
> Should I re-check it with v4.13-rc7?
> 
> Any other suggestions?

Please test it with v4.13-rc7 first.

-- 
Ming
