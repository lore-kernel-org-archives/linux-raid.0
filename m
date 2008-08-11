From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md] Allow raid10 resync to happening in larger chunks.
Date: Mon, 11 Aug 2008 10:37:09 +1000
Message-ID: <18591.35253.346924.997020@notabene.brown>
References: <1217917054-1725-1-git-send-email-neilb@suse.de>
	<1217917054-1725-2-git-send-email-neilb@suse.de>
	<1217917054-1725-3-git-send-email-neilb@suse.de>
	<1217917054-1725-4-git-send-email-neilb@suse.de>
	<1217917054-1725-5-git-send-email-neilb@suse.de>
	<1217917054-1725-6-git-send-email-neilb@suse.de>
	<1217917054-1725-7-git-send-email-neilb@suse.de>
	<20080806090135.GA308@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Keld Jorn Simonsen on Wednesday August 6
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 6, keld@dkuug.dk wrote:
> Neil made this patch based on my patch to speed up raid10 resync.
> 

Yes, thanks for you suggestions.
(and sorry if I seem to have been a bit silent - just busy).

> It is a bit different, although it messes with exactly the two cinstants
> that I also changed. One difference is that Neil intiatlly only allocates
> 1 MiB for buffers while my patch allocates 32 MiB. For the patch to work 
> as intended it is essential that something like 32 MiB be available for
> buffers. I do not see how that is done in Neil's case, but then I do not
> know the code so well.  So how does it work, Neil?

The space controlled by RESYNC_WINDOW is the minimum amount of memory
to preallocate.  This amount is reserved for the duration of the
resync process and the resync process will not start unless it is
available.

The buffers for reading and writing data for the resync are allocated
using a "mempool".  You tell the mempool a minimum size when you
create it, and it will reserve this much memory and make sure it is
always available.  If you as the mempool for more memory, it will get
it if it can, or will block until some of the reserved memory is
returned. 

So the amount preallocated in a mempool should really be the minimum
amount of memory that will allow reasonable forward progress to be
made.  Preallocating a large amount because it makes things go fast is
the wrong approach.  Using as much as is easily available is a good
approach.  Arguably RESYNC_WINDOW should be quite a bit smaller -
maybe just twice RESYNC_BLOCK_SIZE, and RESYNC_DEPTH could be quite a
bit larger.

The import limit on RESYNC_DEPTH relates to latency.  If a normal IO
access arrives at the device, it has to wait for all pending resync IO
to complete before it can start.  If RESYNC_DEPTH is too high (and
there is enough available memory to support it), then it could be
multiple seconds before the regular IO request gets a look-in.

I should probably reduce the RESYNC_WINDOW for raid1 too, and increase
the RESYNC_DEPTH, but it doesn't seem so important there.

> 
> Has your patch been tested, Neil?

Yes, though on my hardware I don't see the same improvement that Jon
does.
More testing is always welcome!

> 
> Anyway if this i a difference between 32 MiB being available or not, I
> think it is important that it be available at the start of the process
> and available for the whole duration of the process. Is it a concern of
> whether 32 Mib buffers be available? My take is that if you are running
> raid, then you probably always have quite some memory. 

Assumptions like that are dangerous.  It could be that you have lots
of memory, but have lots of users of it too.  It could be that you
don't have much.
Certainly we don't need to try to fit inside 64K any more, but a good
principle is to make do with a little as possible, but make use of as
much as is available.
The raid10 resync process is constantly allocating new memory and freeing
old memory.  That means that the VM has the opportunity to use memory
for other demands as they arrive, and provide any spare memory to
resync.  This should make everyone happy.

Thanks,
NeilBrown
