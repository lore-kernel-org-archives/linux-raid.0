From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 reconstruction ?
Date: Sun, 31 May 2009 13:11:44 +0100
Message-ID: <4A227400.7080703@anonymous.org.uk>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>	<4A213612.7080206@anonymous.org.uk>	<1243699735.5740.103.camel@localhost>	<878wkezagw.fsf@frosties.localdomain>	<1243712247.5740.105.camel@localhost>	<37d33d830905310102m451f26aaw8e233227cda491c@mail.gmail.com> <87ljod7aiy.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ljod7aiy.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/05/2009 12:54, Goswin von Brederlow wrote:
> SandeepKsinha <sandeepksinha@gmail.com> writes:
>>> On Sat, 2009-05-30 at 20:55 +0200, Goswin von Brederlow wrote:
>>>> And just when I hit send I thought of something else.
>>>>
>>>> Instead of the initial sync when creating a raid the bitmap could just
>>>> mark all blocks as unused. Much faster raid creation.
>>
>> This really sounds like a good option. This would have a slight hit
>> for writes which I believe will compensate for later re-constructions,
>> replacing a disk, mirror resysnc and many more operation.
> 
> What hit? Currently with bitmap support a write will set the block to
> "unclean", write the data, write the parity and set the block to
> "clean". Setting the "used" bit along the way should not cost much.
> 
> Only difference I see is that the bitmap would have to have finer
> granularity so one "used" bit covers one filesystem block (4k usualy).
> Otherwise you could only "use" blocks but not "unuse" them again when
> the filesystem frees them in 4k chunks.

I think the whole thing probably ought to be done in such a way as to 
support the pass-down and pass-through of TRIM/DISCARD commands, which I 
vaguely recall from previous discussions operate at sector granularity. 
The idea would be for md to be able to use a bitmap (or other some other 
data structure for a free/used block/sector list) when operating over 
devices which don't support TRIM/DISCARD themselves, but take advantage 
of the devices' own capability when it's there - and since it'll be 
SSDs, we'd want to avoid repeatedly rewriting a bitmap since the point 
of TRIM/DISCARD is to help SSDs manage wear levelling.

I am assuming that devices supporting TRIM/DISCARD are able to indicate 
whether a given sector is used or free; if they don't and just return 
arbitary data we would have to keep a bitmap (or whatever) in md to be 
able to support TRIM/DISCARD at all.

Of course any bitmap (or whatever) might still be optimised if we know 
md and its clients never use anything smaller than e.g. 4k.

Cheers,

John.
