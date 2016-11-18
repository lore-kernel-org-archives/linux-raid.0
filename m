From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH/RFC] add "failfast" support for raid1/raid10.
Date: Fri, 18 Nov 2016 08:09:41 +0100
Message-ID: <df842afd-c15a-b37d-269a-dba7d08e59e0@suse.de>
References: <147944614789.3302.1959091446949640579.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147944614789.3302.1959091446949640579.stgit@noble>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

(Seeing that it was me who initiated those patches I guess I should
speak up here)

On 11/18/2016 06:16 AM, NeilBrown wrote:
> Hi,
> 
>  I've been sitting on these patches for a while because although they
>  solve a real problem, it is a fairly limited use-case, and I don't
>  really like some of the details.
> 
>  So I'm posting them as RFC in the hope that a different perspective
>  might help me like them better, or find a better approach.
> 
[ .. ]
>  My two main concerns are:
>   - does this functionality have any use-case outside of mirrored
>     storage arrays, and are there other storage arrays which
>     occasionally inserted excessive latency (seems like a serious
>     misfeature to me, but I know few of the details)?
Yes, there are.
I've come across some storage arrays which really take some liberty when
doing internal error recovery; some even take up to 20 minutes
before sending a command completion (the response was "there's nothing
in the SCSI spec which forbids us to do so")

>   - would it be at all possible to have "real" failfast functionality
>     in the block layer?  I.e. something that is based on time rather
>     than retry count.  Maybe in some cases a retry would be
>     appropriate if the first failure was very fast.
>     I.e. it would reduce timeouts and decide on retries based on
>     elapsed time rather than number of attempts.
>     With this would come the question of "how fast is fast" and I
>     don't have a really good answer.  Maybe md would need to set a
>     timeout, which it would double whenever it got failures on all
>     drives.  Otherwise the timeout would drift towards (say) 10 times
>     the typical response time.
> 
The current 'failfast' is rather a 'do not attempt error recovery' flag;
ie the SCSI stack should _not_ start error recovery but rather pass the
request upwards in case of failure.
Problem is that there is no real upper limit on the time error recovery
could take, and it's virtually impossible to give an I/O response time
guarantees once error recovery had been invoked.
And to make matters worse, in most cases error recovery won't work
_anyway_ if the transport is severed.
So this is more to do with error recovery, and not so much on the time
each request can/should spend on the fly.

The S/390 DASD case is even worse, as the DASD driver _by design_ will
always have to wait for an answer from the storage array. So if the link
to the array is severed you are in deep trouble, as you'll never get a
completion (or any status, for that matter) until the array is reconnected.

So while the FAILFAST flag is a mere convenience for SCSI, it's a
positive must for S/390 if you want to have a functional RAID.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
