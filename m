From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch checksum
Date: Thu, 6 Nov 2014 07:59:43 +0530
Message-ID: <CAK-d5dYHf4n8s2xBi4q-QQ=anV5m+kt2ic1wC1jQxiGBEUg9aw@mail.gmail.com>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
 <20141029200501.1f01269d@notabene.brown> <CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
 <54513FB8.2050407@shiftmail.org> <CAK-d5dZgsoy+PF2urM=N1F67w7nLGyc83muyNoT2h+gQt5ODnQ@mail.gmail.com>
 <20141030172500.GA2591@lazy.lzy> <CAK-d5dbL0wwC0jWgHG5KKLHgJfJ3t7=8Y7cEW=Qo1WHYA+jZbA@mail.gmail.com>
 <20141101125513.GB2078@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141101125513.GB2078@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Ethan Wilson <ethan.wilson@shiftmail.org>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1 November 2014 18:25, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> On Fri, Oct 31, 2014 at 04:35:11PM +0530, Anshuman Aggarwal wrote:
>> Hi pg,
>> With MD raid striping all the writes not only does it keep ALL disks
>> spinning to read/write the current content, it also leads to
>> catastrophic data loss in case the rebuild/disk failure exceeds the
>> number of parity disks.
>
> Hi Anshuman,
>
> yes but do you have hard evidence that
> this is a common RAID-6 problem?
> Considering that we have now bad block list,
> write intent bitmap and proactive replacement,
> it does not seem to me really the main issue,
> having a triple fail in RAID-6.
> Considering that there are available libraries
> for more that 2 parities, I think the multiple
> failure case is quite a rarity.
> Furthermore, I suspect there are other type
> of catastrophic situation (lighting, for example)
> that can destroy an array completely.

I have most definitely lost data when a drive fails and during
reconstruction another drive fails (remember the array has been
chugging away all drives active for 2-3 years). At this point I'm dead
scared of losing another one to avoid catastrophic. If I dont' go out
and buy a replacement right away i'm on borrowed time for my whole
array. For home use this is not fun.

>
>> But more importantly, I find myself setting up multiple RAID levels
>> (at least RAID6 and now thinking of more) just to make sure that MD
>> raid will recover my data and not lose the whole cluster if an
>> additional disk fails above the number of parity!!! The biggest
>> advantage of the scheme that I have outlined is that with a single
>> check sum I am mostly assure of a failed disk restoration and worst
>> case only the media (movies/music) on the failing disk are lost not on
>> the whole cluster.
>
> Each disk will have its own filesystem?
> If this is not the case, you cannot say
> if a single disk failure will lose only
> some files.

Indeed, each device will indeed be an independent block device and
file system. Joined together by some union FS if the user so requires
but that's not in scope for this discussion.

>
>> Also in my experience about disks and usage, while what you are saying
>> was true a while ago when storage capacity had not hit multiple TBs.
>> Now if I am buying 3-4 TB disks they are likely to last a while
>> especially since the incremental % growth in sizes seem to be slowing
>> down.
>
> As wrote above, you can safely replace
> disks before they fail, without compromising
> the array.

Same point above. For home use, I might be away or not have time to
give the array the TLC (tender loving care ;) it needs which is the
only shortcoming of MD really...its hard on the disks  and has
potential of compromising the whole array (giving super fast R/W
performance in return for sure)

>
> bye,
>
> pg
>
>> Regards,
>> Anshuman
>>
>> On 30 October 2014 22:55, Piergiorgio Sartor
>> <piergiorgio.sartor@nexgo.de> wrote:
>> > On Thu, Oct 30, 2014 at 08:27:27PM +0530, Anshuman Aggarwal wrote:
>> >>  What you are suggesting will work for delaying writing the checksum
>> >> (but still making 2 disks work non stop and lead to failure, cost
>> >> etc).
>> >
>> > Hi Anshuman,
>> >
>> > I'm a bit missing the point here.
>> >
>> > In my experience, with my storage systems, I change
>> > disks because they're too small, way long before they
>> > are too old (way long before they fail).
>> > That's why I end up with a collection of small HDDs.
>> > which, in turn, I recycled in some custom storage
>> > system (using disks of different size, like explained
>> > in one of the links posted before).
>> >
>> > Honestly, the only reason to spin down the disks, still
>> > in my experience, is for reducing power consumption.
>> > And this can be done with a RAID-6 without problems
>> > and in a extremely flexible way.
>> >
>> > So, the bottom line, still in my experience, is that
>> > this you're describing seems quite a nice situation.
>> >
>> > Or, I did not understood what you're proposing.
>> >
>> > Thanks,
>> >
>> > bye,
>> >
>> > pg
>> >
>> >> I am proposing N independent disks which are rarely accessed. When
>> >> parity has to be written to the remaining 1,2 ...X disks ...it is
>> >> batched up (bcache is feasible) and written out once in a while
>> >> depending on how much write is happening. N-1 disks stay spun down and
>> >> only X disks wake up periodically to get checksum written to (this
>> >> would be tweaked by the user based on how up to date he needs the
>> >> parity to be (tolerance of rebuilding parity in case of crash) and vs
>> >> disk access for each parity write)
>> >>
>> >> It can't be done using any RAID6 because RAID5/6 will stripe all the
>> >> data across the devices making any read access wake up all the
>> >> devices. Ditto for writing to parity on every write to a single disk.
>> >>
>> >> The architecture being proposed is a lazy write to manage parity for
>> >> individual disks which won't suffer from RAID catastrophic data loss
>> >> and concurrent disk.
>> >>
>> >>
>> >>
>> >>
>> >> On 30 October 2014 00:57, Ethan Wilson <ethan.wilson@shiftmail.org> wrote:
>> >> > On 29/10/2014 10:25, Anshuman Aggarwal wrote:
>> >> >>
>> >> >> Right on most counts but please see comments below.
>> >> >>
>> >> >> On 29 October 2014 14:35, NeilBrown <neilb@suse.de> wrote:
>> >> >>>
>> >> >>> Just to be sure I understand, you would have N + X devices.  Each of the
>> >> >>> N
>> >> >>> devices contains an independent filesystem and could be accessed directly
>> >> >>> if
>> >> >>> needed.  Each of the X devices contains some codes so that if at most X
>> >> >>> devices in total died, you would still be able to recover all of the
>> >> >>> data.
>> >> >>> If more than X devices failed, you would still get complete data from the
>> >> >>> working devices.
>> >> >>>
>> >> >>> Every update would only write to the particular N device on which it is
>> >> >>> relevant, and  all of the X devices.  So N needs to be quite a bit bigger
>> >> >>> than X for the spin-down to be really worth it.
>> >> >>>
>> >> >>> Am I right so far?
>> >> >>
>> >> >> Perfectly right so far. I typically have a N to X ratio of 4 (4
>> >> >> devices to 1 data) so spin down is totally worth it for data
>> >> >> protection but more on that below.
>> >> >>
>> >> >>> For some reason the writes to X are delayed...  I don't really understand
>> >> >>> that part.
>> >> >>
>> >> >> This delay is basically designed around archival devices which are
>> >> >> rarely read from and even more rarely written to. By delaying writes
>> >> >> on 2 criteria ( designated cache buffer filling up or preset time
>> >> >> duration from last write expiring) we can significantly reduce the
>> >> >> writes on the parity device. This assumes that we are ok to lose a
>> >> >> movie or two in case the parity disk is not totally up to date but are
>> >> >> more interested in device longevity.
>> >> >>
>> >> >>> Sounds like multi-parity RAID6 with no parity rotation and
>> >> >>>    chunksize == devicesize
>> >> >>
>> >> >> RAID6 would present us with a joint device and currently only allows
>> >> >> writes to that directly, yes? Any writes will be striped.
>> >> >
>> >> >
>> >> > I am not totally sure I understand your design, but it seems to me that the
>> >> > following solution could work for you:
>> >> >
>> >> > MD raid-6, maybe multi-parity (multi-parity not implemented yet in MD yet,
>> >> > but just do a periodic scrub and 2 parities can be fine. Wake-up is not so
>> >> > expensive that you can't scrub)
>> >> >
>> >> > Over that you put a raid1 of 2 x 4TB disks as a bcache cache device (those
>> >> > two will never spin-down) in writeback mode with writeback_running=off .
>> >> > This will prevent writes to backend and leave the backend array spun down.
>> >> > When bcache is almost full (poll dirty_data), switch to writeback_running=on
>> >> > and writethrough: it will wake up the backend raid6 array and flush all
>> >> > dirty data. You can then then revert to writeback and writeback_running=off.
>> >> > After this you can spin-down the backend array again.
>> >> >
>> >> > You also get read caching for free, which helps the backend array to stay
>> >> > spun down as much as possible.
>> >> >
>> >> > Maybe you can modify bcache slightly so to implement an automatic switching
>> >> > between the modes as described above, instead of polling the state from
>> >> > outside.
>> >> >
>> >> > Would that work, or you are asking something different?
>> >> >
>> >> > EW
>> >> >
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> >> > the body of a message to majordomo@vger.kernel.org
>> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> > --
>> >
>> > piergiorgio
>
> --
>
> piergiorgio
