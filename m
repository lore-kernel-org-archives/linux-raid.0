From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RAID5 reconstruction ?
Date: Tue, 2 Jun 2009 21:54:37 -0400
Message-ID: <87f94c370906021854u7b7684d5m716c028e75b14c14@mail.gmail.com>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>
	 <4A213612.7080206@anonymous.org.uk>
	 <1243699735.5740.103.camel@localhost>
	 <878wkezagw.fsf@frosties.localdomain>
	 <1243712247.5740.105.camel@localhost>
	 <37d33d830905310102m451f26aaw8e233227cda491c@mail.gmail.com>
	 <87ljod7aiy.fsf@frosties.localdomain>
	 <49f399b955a41bf8f6b5c2441d218a96.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49f399b955a41bf8f6b5c2441d218a96.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, SandeepKsinha <sandeepksinha@gmail.com>, Redeeman <redeeman@metanurb.dk>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, May 31, 2009 at 8:14 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, May 31, 2009 9:54 pm, Goswin von Brederlow wrote:
>> SandeepKsinha <sandeepksinha@gmail.com> writes:
>>
>>> On Sun, May 31, 2009 at 1:07 AM, Redeeman <redeeman@metanurb.dk> wrote:
>>>> On Sat, 2009-05-30 at 20:55 +0200, Goswin von Brederlow wrote:
>>>>> And just when I hit send I thought of something else.
>>>>>
>>>>> Instead of the initial sync when creating a raid the bitmap could just
>>>>> mark all blocks as unused. Much faster raid creation.
>>>>
>>>
>>>
>>> This really sounds like a good option. This would have a slight hit
>>> for writes which I believe will compensate for later re-constructions,
>>> replacing a disk, mirror resysnc and many more operation.
>>
>> What hit? Currently with bitmap support a write will set the block to
>> "unclean", write the data, write the parity and set the block to
>> "clean". Setting the "used" bit along the way should not cost much.
>>
>> Only difference I see is that the bitmap would have to have finer
>> granularity so one "used" bit covers one filesystem block (4k usualy).
>> Otherwise you could only "use" blocks but not "unuse" them again when
>> the filesystem frees them in 4k chunks.
>
> But the filesystem could "unuse" blocks in larger chunks.
> There is this thing called "thin provisioning" and I believe the proponents
> of that would like the "TRIM" command to be sent in aligned multiples
> of 1Gigabyte or something like that.
> I believe this is one aspect of Linux TRIM support that is still open.
>
> I think there would be real value in providing an 'allocated'
> bitmap even if it were quite coarsely grained.
> The problem with a very large grain is that every time you set a bit,
> you need to resync that region, and you don't want that to take too long.
> So 1 gig (10-30seconds?) would be an upper limit I would thing.
> If you used 1 sector for the bitmap, that is 4096 bits so on a terabyte
> array, you have 256Meg chunks that resync in a few seconds.
>
> Certainly an interesting idea to experiment with I think.
>
> NeilBrown
>

Neil,

Is there likely to be any discussion of how trim / unmap will be
invoked by the filesystem layer at OLS?  Or how do those decisions get
made?

ie. The ext4 list was recently talking about sending down very small
grained info, but large grained seems to make a lot more sense to me.
Hopefully, each filesystem is not given the ability to decide for
themselves.  Very much seems like something the lk community should
have input into, not just the ext4 maintainer.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
