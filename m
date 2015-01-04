From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Sun, 04 Jan 2015 21:45:22 +0000
Message-ID: <54A9B472.9090905@youngman.org.uk>
References: <20150104210701.GG4713@deb76.aryehleib.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150104210701.GG4713@deb76.aryehleib.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aryeh Leib Taurog <vim@aryehleib.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/01/15 21:07, Aryeh Leib Taurog wrote:
> On Sun, 4 Jan 2015 at 11:10 Peter Grandi wrote:
>> Yet another of an endless (but not too frequent fortunately)
>> stream of "wildly optimistic" messages to this mailing list...
> 
> No intent to offend.  I specifically put "newbie" in the subject.
> 
>>> Would the resync just copy all the data from the "good" drive
>>> back to the "failed" drive?
>>
>> This seems to me quite "imaginative" based on the dream that
>> resync has psychic powers.
> 
> I am not sure what you mean.  Two drives in a RAID1 array.  At one 
> point, one drive failed to come on line.  Now mdadm refuses to include 
> that drive in the array.  So there's the "good" drive, which appears 
> in the now degraded array, and the "failed" drive, which does not.  I 
> have never done a resync, and I haven't seen a detailed description of 
> what it does, but given that mdadm seems to have decided which drive 
> is good and which not, and assuming mdadm doesn't know anything about 
> the contents of the data, what is so "imaginative" about the notion 
> that if I add the "failed" drive to the array, it would simply copy 
> all the data on the "good" drive byte-by-byte onto the "failed" drive, 
> overwriting whatever is currently on the "failed" drive?  I can't 
> imagine how else a resync would work.  What am I missing?

That mirroring isn't fault-tolerant-raid? I know it's been given a raid
classification, but raids 1 and 0 really just give you a bigger faster
disk. It's only the other raids that have any error correction ability,
because they use parity etc to be able to tell which set of data is correct.
> 
>>> For diagnostic purposes, it would actually be a lot more
>>> informative to compare the two drives and see if there really
>>> is data corruption on one of them or not.
>>
>> This seems to me "wildly optimistic" that when two blocks differ
>> it is possible in the general case to determine whether one (and
>> which one) or both are "corrupted".
> 
> I was only referring to my specific case.  One drive was found to have 
> faulty hardware, one not.  The one with the faulty hardware is 
> suspect, the other not.  If the two differ, then I, perhaps naively, 
> would assume that the suspect drive experienced data corruption and 
> the other not.  To my mind, whether they differ or not could indicate 
> something about the condition of the hardware and may have potentially 
> useful implications regarding data on drives previously used (without 
> MD) in the suspect hardware.  If I'm wrong, I'd be thrilled to learn.
> 
>>> Is there a way to do that?
>>
>> 'man cmp' may show a way to "compare the two drives".
> 
> I am quite familiar with the unix toolset.  But I don't know enough 
> about mdadm.  Where, for example, is the superblock, and where do my 
> data begin?  I gather the superblock is expected to differ, since each 
> device has a UUID and distinct event count.  I read the mdadm man 
> page, but it doesn't seem to discuss implementation details such as 
> this.  So if there's no mdadm-specific approach, it would help to know 
> where on the device I could find the data that I should expect to 
> match, or alternatively, why I should not interest myself in such a 
> comparison.
> 
>>> If I were to demonstrate that the data are in sync, I would
>>> want to reassemble without resync.
>>
>> "Fantastic logic".
> 
> Please help me understand.  It's a RAID1 array.  Doesn't that mean the 
> devices are supposed to have identical copies of the data?  And if I 
> can demonstrate that they in fact are identical, why would a resync be 
> necessary?  I am sure I am missing something.  Please clue me in.

They are supposed to be identical. But since the raid came up with one
drive missing, the other drive may have been modified, so they're not
identical any more. And the raid array has NO WAY of knowing which
version is "correct". Sorry :-( but that's mirrors for you ...
> 
>>> Also, in my situation, since for now I'm just using a pair of
>>> external drives, I could easily imagine accidentally trying to
>>> assemble the array when one of the drives is powered down.
>>> Then this situation would arise again without faulty hardware.
>>
>> This may be based on the "amazing insight" that differences in
>> content and event counts are the same as data corruption.
> 
> Again, I fail to comprehend.  If anything, I assumed the opposite.  It 
> was my understanding that a difference in event counts could very 
> easily arise without data corruption, as could differences in content.  
> It also seems obvious that data corruption could occur in ways that 
> would affect all drives in an array.  But I don't understand how any 
> of this is relevant.

If there's differences in event counts and content, then the drives are
no longer identical. Reassemble the array, without a resync, and things
could get complicated (and nasty) VERY quickly :-(
> 
>>> Prudence notwithstanding, I do think there are valid cases for 
>>> reassembling this array without resync.
>>
>> I believe that you think that but I also believe the manual when
>> it says "Use this only if you really know what you are doing";
>> because many MD users may not have the level of skills and
>> insight about RAID that you think you have, MD is designed to
>> protect users by default from their own "amazing optimism",
>> especially users that haven't read yet:
>>
>>  https://raid.wiki.kernel.org/index.php/RAID_Recovery
>>  https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID
> 
> I don't think I have any skill or insight about RAID.  I would like to 
> learn and understand.  I have read the linked material, as well as the 
> mdadm man page a few times, but it seems to me there are some basic 
> concepts which aren't explained clearly.  It does say that when in 
> doubt one should contact "the friendly and helpful folk on the 
> linux-raid mailing list."
> 
>>> If there's a way to do that, I'd still like to know.
>>
>> 'man mdadm' may show a way to assemble "without resync".
> 
> I didn't find it.  As I said, it seems to me one needs much more 
> experience and understanding of MD than I have to understand most of 
> that document.  There is an indication in the RAID_Recovery wiki page 
> that I can reissue the original --create command with --assume-clean, 
> but there's more discussion about why it might not work than about 
> what it actually does.  It also encourages contacting the mailing list 
> first, which I have done, hoping to gain some insight.

The problem with "--create --assume-clean", is that if the array isn't
clean (and in this case it isn't - we don't know what is different
between the drives but *something* is), then you're asking for trouble.
> 
> I'd like to think you didn't mean to be offensive, condescending, or 
> hyperbolic, and I'm not trying to flame, but I'm feeling very 
> defensive after reading your message, and none the wiser.  That may 
> have come out in my response, despite my best efforts.  I read what I 
> could find about MD before posting, but it seems to me there's some 
> basic information which isn't documented in the places I've looked.  I 
> tried searching the mailing list, but finding a needle in a haystack 
> is much harder when you don't know what a needle looks like.
> 
I know it's hard if you don't know what a needle looks like, but in this
case I think the analogy is very apt - if you go looking you are going
to stab yourself with it.

I think you are going to have to bite the bullet and resync. Maybe keep
the existing drive as a backup, get a new drive, and resync to that.
Make that you backup regime - once a month or whatever swap one drive
over as a backup.

The alternative is get another drive and go raid-5 - but see all the
threads warning about using raid 5 with consumer drives - you need to
tweak your system settings otherwise transient faults can break your system.

And at the end of the day, a resync may take time, but it won't have
much impact on you using your system. I've got mirrored 3TB drives, and
the resync when I brought the array up (I moved a non-mirrored system on
to one drive "--create /dev/disk1 missing" then added the other) just
ticked over in the background.

Cheers,
Wol

