From: Neil Brown <neilb@suse.de>
Subject: Re: Resize on dirty array?
Date: Mon, 28 Aug 2006 14:55:21 +1000
Message-ID: <17650.30521.355859.724575@cse.unsw.edu.au>
References: <44D7DC93.2070905@net1plus.com>
	<17623.57067.835826.446152@cse.unsw.edu.au>
	<44D8E535.9080208@net1plus.com>
	<17625.24594.568139.430440@cse.unsw.edu.au>
	<44D9C6F5.7070501@net1plus.com>
	<5b170a7d0608120022n39742f2cl8f8017f6cc328f5e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tuomas Leikola on Saturday August 12
Sender: linux-raid-owner@vger.kernel.org
To: Tuomas Leikola <tuomas.leikola@gmail.com>
Cc: James Peverill <jamespev@net1plus.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday August 12, tuomas.leikola@gmail.com wrote:
> On 8/9/06, James Peverill <jamespev@net1plus.com> wrote:
> >
> > I'll try the force assemble but it sounds like I'm screwed.  It sounds
> > like what happened was that two of my drives developed bad sectors in
> > different places that weren't found until I accessed certain areas (in
> > the case of the first failure) and did the drive rebuild (for the second
> > failure).  In the future, is there a way to help prevent this?
> 
> This is a common scenario, and I feel could be helped if md could be
> told to not drop the disk on first failure, but rather keep it running
> in "FAILING" status (as opposed to FAILED), until all data from it has
> been evacuated (hot spare). This way, if another disk became "failing"
> during rebuild, due to another area of the disk, those blocks could be
> rebuilt using the other "failing" disk. (Also, this allows for the
> rebuild to mostly be a ddrescue-style copy operation, rather than
> parity computation).
> 
> Do you guys feel this is feasible? Neil?

Maybe....
I would be a lot happier about it if the block layer told me whether
the fail was a Media error or some other sort of error.

But something could probably be arranged, and the general idea has been
suggested a number of times now, so maybe it really is a good idea :-)
I'll put it on my todo list :-)

NeilBrown
