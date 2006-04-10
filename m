From: Neil Brown <neilb@suse.de>
Subject: Re: linear writes to raid5
Date: Mon, 10 Apr 2006 10:50:23 +1000
Message-ID: <17465.43983.345817.253532@cse.unsw.edu.au>
References: <m37j60udi8.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alex Tomas on Saturday April 8
Sender: linux-raid-owner@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 8, alex@clusterfs.com wrote:
> 
> Good day all,
> 
> is there a way to batch explicitely write requests raid5 issues?
> for example, there is a raid5 built from 3 disks with chunk=64K.
> one types dd if=/dev/zero of=/dev/md0 bs=128k count=1 and 128K
> bio gets into the raid5. raid5 processes the request, does xor
> for parity stripe, then issues 2 64KB requests down to lower level.
> 
> is it even possible to implement? if so, how complex?
> 
> I suppose we could introduce a context which holds last
> non-issued bio and instead of generic_make_request() in 
> handle_stripe() try to merge current request to the previous
> one from the context? how does this sound to you?

The raid5 code attempts to do this already, though I'm not sure how
successful it is.  I think it is fairly successful, but not completely
successful. 

There is a trade-off that raid5 has to make.  Waiting longer can mean
more blocks on the same stripe, and so less reads.  But waiting longer
can also increase latency which might not be good.

The thing to would be to put some tracing in to find out exactly what
is happening for some sample workloads, and then see if anything can
be improved.

NeilBrown
