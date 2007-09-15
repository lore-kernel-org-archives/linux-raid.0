From: Iustin Pop <iusty@k1024.org>
Subject: Re: MD RAID1 performance very different from non-RAID partition
Date: Sat, 15 Sep 2007 14:32:17 +0200
Message-ID: <20070915123217.GC21515@teal.hq.k1024.org>
References: <46EB6D67.1000802@quo.to> <20070915070914.GA21515@teal.hq.k1024.org> <87ejh03ywk.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87ejh03ywk.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Jordan Russell <jr-list-2007@quo.to>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 15, 2007 at 02:18:19PM +0200, Goswin von Brederlow wrote:
> Shouldn't it be the other way around? With a barrier the filesystem
> can enforce an order on the data written and can then continue writing
> data to the cache. More data is queued up for write. Without barriers
> the filesystem should do a sync at that point and have to wait for the
> write to fully finish. So less is put into cache.

I don't know in general, but XFS will simply not issue any sync at all
if the block device doesn't support barriers. It's the syadmin's job to
either ensure you have barriers or turn off write cache on disk (see the
XFS faq, for example).

However, I never saw such behaviour from MD (i.e. claiming the write has
completed while the disk underneath is still receiving data to write
from Linux) so I'm not sure this is what happens here. In my experience,
MD acknowledges a write only when it has been pushed to the drive (write
cache enabled or not) and there is no buffer between MD and the drive.

regards,
iustin
