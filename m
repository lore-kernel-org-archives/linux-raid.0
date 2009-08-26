From: "NeilBrown" <neilb@suse.de>
Subject: Re: man mdadm regarding --assume-clean says it's OK to use with
     RAID1  or 10, when creating:
Date: Wed, 26 Aug 2009 10:25:20 +1000 (EST)
Message-ID: <d62c5621e94b3c98b253ecf78c6cb701.squirrel@neil.brown.name>
References: <43d009740908220701j25b26bd8o4ac0030121544c32@mail.gmail.com>
    <c268e4660908221046x6e461de1u3c6e36f1a7e4021c@mail.gmail.com>
    <43d009740908221048w2b76f14fwae6abdec1b098bcf@mail.gmail.com>
    <b5c57585f8e55bf526f86418980dfbb4.squirrel@neil.brown.name>
    <43d009740908222221w5f5ae3b4qa224322ce0e763c6@mail.gmail.com>
    <19092.25831.449670.747732@notabene.brown>
    <f19d625d0908251634g43a51263m7829554f3a0fb00f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f19d625d0908251634g43a51263m7829554f3a0fb00f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: for.poige+linux@gmail.com, Drew <drew.kay@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, August 26, 2009 9:34 am, CoolCold wrote:
> On Wed, Aug 26, 2009 at 2:25 AM, Neil Brown <neilb@suse.de> wrote:
>>
>> On Sunday August 23, for.poige+linux@gmail.com wrote:
>> > 2009/8/23 NeilBrown <neilb@suse.de>:
>>
>> That is correct - chunk size only affect data layout, not IO size.
>> md/raid5 always reads or writes a whole page (normally 4K) at a time.
>>
>> NeilBrown
>>
>>
>
> Hmm...so how read from some program -> fs -> md happens then? I.e. -
> if FS has stride/stripe/swidth for, say, 64kb (and md chunk size is
> 64kb), some program requests 128kb of data to be read, does it mean
> we'll do 16 reads for 4kb from two drives? Even if we do, is it
> right/good ?

Actually it is a bit more complicated than that.
Md/raid5 tries to encourage the filesystem to submit read requests is sizes
that fit inside one chunk.  When md/raid5 gets such a read request,
and it is for a device that has not failed and no reshape is happening
(and maybe some other conditions), it will forward the read request
down to the drive that can serve it.

If any of these conditions aren't met, then the read request will
be split in to 4K chunks and each chunk will be handled separately,
possibly reconstructing from other devices if that is needed etc.
However if a number of consecutive 4K reads (or writes) are submitted
to a device, the driver for that device will normally assemble
those requests together into fewer larger requests so you shouldn't
get lots of little request going out to the device unless there
are lots of little requests coming down from the filesystem.

NeilBrown

