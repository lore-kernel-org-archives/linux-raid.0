From: Phil Turmel <philip@turmel.org>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Sat, 25 Feb 2017 19:07:06 -0500
Message-ID: <657e80e9-b1f5-1f58-a4d0-6cbc4cc44927@turmel.org>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
 <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
 <20170224084024.4dfe83a2.ian_bruce@mail.ru>
 <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
 <c23b2aca-b6e6-37b8-3238-e59423d8f5a7@youngman.org.uk>
 <aee1f55b-cedf-15e9-5865-7fc0cdf9a188@turmel.org>
 <58B2137B.6070608@youngman.org.uk>
 <5172e2ab-e193-477b-52c4-86fbab0d52fe@turmel.org>
 <58B21987.6060604@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58B21987.6060604@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/25/2017 06:55 PM, Wols Lists wrote:
> On 25/02/17 23:41, Phil Turmel wrote:
>>> Is there a sound technical reason not to go there, or is it simply a
>>>> case of "learn another tool for that job"? The less tools I have to know
>>>> the better, imho.
> 
>> Um, no, imnsho.  Learn new tools when you need them.
> 
> I don't have a problem with that. All too often people use the tool
> they're familiar with when it's the wrong tool. But there's a reason
> they do that - it's a familiar tool!
>>
>> Linux raid has no formal mechanism to cleanly separate a mirror from a
>> running array, access it as a backup, and not risk corruption when
>> re-attaching it to the array.  Most filesystems write to the partition
>> when mounting, even for read-only mounts.  You cannot safely access the
>> disconnected member except via pure block reads.
> 
> Because to do so doesn't make sense? Or because nobody's bothered to do
> it? I get grumpy when people implement corner cases without bothering to
> implement the logically sensible options - bit like those extremely
> annoying dialog boxes that give you three choices, "yes", "no", "yes to
> all". What about no to all?

Because while disconnected, and the array begins accumulating
write-intent bits indicating where any disconnected device is out of
date, the array has no way to know what writes are happening to that
member.  And therefore any re-add will introduce unknowable corruptions.
 There is no way to control what writes happen to that member, and
drives don't naturally keep a log of writes that have happened.  The data to
safely do what you want simply doesn't exist.  Your only known safe
choice is to disable write-intent bitmaps, forcing complete resync on
--re-add.

> I feel like mirror-raid is perfect for doing backups.

Your feelings are wrong.  Sorry.  LVM is the perfect tool because it
entirely controls the snapshot and doesn't have to re-add it.

> I take your point
> that linux hasn't implemented that feature (particularly well), but
> surely it's a feature that *should* be there. I know I know - "patches
> welcome" :-)

Good luck creating the necessary data from thin air.  It's not a
question of writing patches.

Phil
