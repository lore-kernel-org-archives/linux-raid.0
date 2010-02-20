From: Neil Brown <neilb@suse.de>
Subject: Re: Maybe crazy idea for reshaping: Instant/On-Demand reshaping
Date: Sat, 20 Feb 2010 19:40:20 +1100
Message-ID: <20100220194020.5d1689e6@notabene.brown>
References: <87zl34xyqt.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zl34xyqt.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 20 Feb 2010 06:27:54 +0100
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> Hi,
> 
> last night I started a reshape of a raid5 array. Now I got up and it is
> still over 15 hours till the reshape is done. That got me thinking.
> Since I haven't had my coffee yet let me use you as a sounding board.
> 
> 
> 1) Wouldn't it be great if during reshape the size of the raid would
> gradualy increase?
> 
> As the reshape progresses and data moves from X to X+1 disks it creates
> free space. So why can't one increase the device size gradually to
> include that space?
> 
> Unfortunately the space it frees is needed to reshape the later
> stripes. As it reshapes a window of free space moves from the start of
> the disks to the end of the disks. For the device size to grow the place
> where the new stripe would land after reshaping needs to be free and
> that means the window of free space must have moved far enough to
> include that place. That means X/(X+1) of the data has already been
> copied. Only while copying the last 1/(X+1) of data could the size
> increase. That would still be a plus.
> 
> Note: After all the data has been copied, when the window of free space
> has reached the end of the disks, there is still work to do. The window
> of free space contains random data and needs to be resynced or zeroed so
> the parity of the future stripes is correct. For the size to increase
> gradually that resync/zeroing would have to be interleaved with copying
> the remaining data.
> 
> 
> 2) With the existing reshape a gradual size increase is impossible
> untill late in the reshape. Could we do better?
> 
> The problem with increasing the size before the reshape is done is that
> there is existing data where our new free space is going to be. Maybe we
> could move the data away as needed. Whenever something writes to a new
> stripe that still contains old data we move the old stripe to its new
> place. That would require information where old data is. Something like
> a bitmap. We might not get stripe granularity but that is ok.
> 
> It gets bit more complex. Moving a chunk of old data means writing data
> to new stripes. They can contain old data as well requiring a recursion.
> But old data always gets copied to lower blocks. Assuming we finished
> some reshaping at the start of the disks (at least some critical section
> must be done) then eventually we hit a region that was already reshaped.
> As the reshape progresses it will take less and less recursions.
> 
> Note: reads from stripes with old data would return all 0.
> 
> Note 2: writing to a stripe can write to the old stripe if that wasn't
> respahed yet.
> 
> Note 3: there would still be a normal reshape process that goes from
> start to end on each disk, it would just run in parallel with the
> on-demand copying.
> 
> Writing to a new stripe that hasn't yet been reshaped will be horribly
> slow at first and gradually become faster as the reshape progresses.
> Also as more new stripes get written there will be more and more chunks
> in the middle of the disks that have been reshaped so the recursion will
> not have to go to the fully reshaped region at the start of the disk
> every time.
> 
> 
> So what do you think? Is this lack of cafein speaking?

I think your cost-benefit trade-off is way off balance on the cost side.

This sort of complexity really belongs in a filesystem, not in a a block
device.

NeilBrown
