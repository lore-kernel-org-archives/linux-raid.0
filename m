From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Fri, 10 Jan 2020 01:55:37 +0000
Message-ID: <5E17D999.5010309@youngman.org.uk>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
 <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk>
 <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Morgan <therealbrewer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/01/20 01:19, William Morgan wrote:
> Thank you for the encouraging response. I think I would like to
> attempt to rescue the smaller array first as the data there is
> somewhat less crucial and I may learn something before working with
> the more important larger array.
> 
>>> md1 consists of 4x 4TB drives:
>>>
>>> role drive events state
>>>   0    sdj    5948  AAAA
>>>   1    sdk   38643  .AAA
>>>   2    sdl   38643  .AAA
>>>   3    sdm   38643  .AAA
>>
>> This array *should* be easy to recover. Again, use overlays, and
>> force-assemble sdk, sdl, and sdm. DO NOT include sdj - this was ejected
>> from the array a long time ago, and including it will seriously mess up
>> your array. This means you've actually been running a 3-disk raid-0 for
>> quite a while, so provided nothing more goes wrong, you'll have a
>> perfect recovery, but any trouble and your data is toast. Is there any
>> way you can ddrescue these three drives before attempting a recovery?
> 
> I do have plenty of additional disk space. If I try ddrescue first,
> will that just give me a backup of the array in case something goes
> wrong with the force-assemble with overlays? Can you give me some
> guidance on what to do with ddrescue?
> 
Firstly, the whole point of overlays is to avoid damaging the arrays -
done properly, any and all changes made to the array are actually
diverted to files elsewhere so when you shut down all the changes are
lost and you get the unaltered disks back. So the idea is you assemble
the array with overlays, inspect the data, check the disk with fsck etc,
and if it all looks good you know you can assemble the array without
overlays and recover everything.

Of course, things can always go wrogn ... so ddrescue makes a backup.
Depending on how you want to do it, just use ddrescue exactly as you
would use dd. You can copy your disk, eg "dd if=/dev/sdm of=/dev/sdn" -
just MAKE SURE you get the arguments right to avoid trashing your
original disk by mistake, or you can copy the disk or partition to a
file eg "dd if=/dev/sdj of=/home/rescue/copy_of_sdj".

If you're not happy using overlays, having ddrescue'd the disks you
could always assemble the array directly from the copies and make sure
everything's okay there, before trying it with the original disks.

Note that there is no difference as far as the *user* is concerned
between dd and ddrescue. Under the hood, there's a lot of difference -
ddrescue is targeted at failing hardware so while it tries to just do a
simple copy it doesn't fail on read errors and has a large repertoire of
tricks to try and get the data off. It doesn't always succeed, though
... :-)

Cheers,
Wol
