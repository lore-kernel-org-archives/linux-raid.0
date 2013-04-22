From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] DM RAID: Add ability to restore transiently failed devices on resume
Date: Mon, 22 Apr 2013 13:57:03 -0500
Message-ID: <503B3DAE-0E23-44AC-B828-74B7BE9B4CE8@redhat.com>
References: <1365712023.9799.1.camel@f16> <20130422104326.217ef2f8@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130422104326.217ef2f8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Apr 21, 2013, at 7:43 PM, NeilBrown wrote:

> On Thu, 11 Apr 2013 15:27:03 -0500 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> DM RAID: Add ability to restore transiently failed devices on resume
>> 
>> This patch adds code to the resume function to check over the devices
>> in the RAID array.  If any are found to be marked as failed and their
>> superblocks can be read, an attempt is made to reintegrate them into
>> the array.  This allows the user to refresh the array with a simple
>> suspend and resume of the array - rather than having to load a
>> completely new table, allocate and initialize all the structures and
>> throw away the old instantiation.
>> 
>> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
> 
> Is this really a good idea?  
> Just because you can read the superblock, that doesn't mean you can read any
> other block in the array.

True.  To some extent, we are relying on user-space here.  The normal life of a DM device would consist of:
1) constructor (CTR)
2) resume
3) suspend (sometimes skipped)
4) destructor (DTR)

It is pretty rare to get a secondary 'resume'.  A DM device is normally suspended so that a different table can be loaded - in which case, the first instance is destroyed (DTR) and the second instance undergoes its first resume.  Another case that does happen, albeit rarely, is a "refresh" (e.g. 'lvchange --refresh vg/lv').  This operation performs a suspend/resume for the purpose of refreshing the in-kernel target.  This is the situation that I am trying to instrument with this patch.  You can see from the patch that it is only secondary 'resumes' where the check is made.

To say that there is no other case where a secondary resume would be done would be silly.  I can't account for every case.  However, the user must be resuming an existing target after a suspend (not a CTR) which is somewhat rare.  There must be a failed device in the array for the subsequent superblock read to be performed and that must succeed for the device to attempt revival.  If the device is really still in bad shape, it will fall back to 'Faulty'.

The approach I had been using in user-space was to load a completely new (and identical) mapping table.  The old table and structures were discarded and all the state of the devices was lost.  The new table was instantiated with new structures and all devices assumed to be fine.  (It would, of course, be noticed that a device had failed and must be recovered, but it would be assumed that it was alive and able to do so.)  User-space would do this partially based on the fact that the LVM label could be read from the disk and partially from the fact that the user had made the decision to run the 'lvchange --refresh' command in the first place.  This seems to be far more messy than possibly reviving the device in the 'resume'.

Another possibility is to put this functionality into the 'message' interface.  Any 'refresh' command could use that.  Then, the cases I am unable to account for that issue secondary resumes would not also have the side effect of trying to revive any failed devices that may exist in the array who just happen to have readable superblocks.  However, it is nice to have the device suspended when the device revival is attempted.  If we put the revival code into the 'message' function, I may have to wrap the revival code with a suspend and resume anyway - not sure yet.

Personally, I like having the revival code in the 'resume' over the 'message' function.  I'll make sure Alasdair gets a copy of this message to see if he has an opinion.

> 
> If the auto-recovery were optional I might consider it, but having it be
> enforced on every suspend/resume just doesn't seem safe to me.
> 
> Have I misunderstood?
> 
> Is this that hard to achieve in user-space?
> 
> 
>> +			if (test_bit(Faulty, &r->flags) && r->sb_page &&
>> +			    !read_disk_sb(r, r->sb_size)) {
> 
> I know it is fairly widely used, especially for 'strcmp', but I absolutely
> despise this construct.
>  !read_disk_sb()
> sound like
>  "not read_disk_sb" or "could not read the disk's superblock" but it
> actually means "did not fail to read the disk's superblock" - the exact
> reverse.
> If 0 means success, I like to see an explicit test for 0:
>   read_disk_sb() == 0

Ok, I'll try to remember that.  This issue has solved itself though, because I must switch to using sync_page_io directly anyway.  I'll have to post another patch whether we proceed or decide to change where we put this code.

 brassow

