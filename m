From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Wed, 6 Dec 2017 11:21:18 -0500
Message-ID: <1b43be27-f21a-1fba-f983-01c5356a654d@turmel.org>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru>
 <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de>
 <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
 <20171206160346.GA5806@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171206160346.GA5806@metamorpher.de>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Jeremy Graham <jeremy@doghouse.agency>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/06/2017 11:03 AM, Andreas Klauer wrote:
> On Wed, Dec 06, 2017 at 09:15:21AM -0500, Phil Turmel wrote:
>> The problem with this is that the sectors currently marked don't have
>> appropriate data.
> 
> It might have the correct data. Depends what exactly happened.
> If it happened years ago and you never noticed until reshape, 
> chances are it won't matter one way or another.

No, almost certainly not the correct data.  The data that was attempted
to be written at the time the BB was added didn't make it to disk, and
any future updated data writes would be skipped since it's in the list.

> Of course, it doesn't hurt to take additional steps, if you have 
> backups to compare with or some other way to check file integrity. 

If you check integrity before deleting the BBL, MD reconstructs the
data.  If you check integrity after deleting the BBL, MD is giving you
the garbage (because it doesn't know to reconstruct).

>>> If you have a filesystem with bad blocks management on top of it, 
>>> check that too and clear it if necessary.
>>
>> MD's BBL system doesn't coordinate with the filesystem on top, so this
>> is meaningless.
> 
> MD with duped BBLs does return read errors, so it's a possibility.

No, it doesn't.  The read error is only passed to the filesystem if
there's no redundancy left for the block address.

>> The BBL in MD is woefully incomplete and should *never* be used.
> 
> There's ups and downs to everything. Relocations would be awful too. 
> Harms performance and makes recovery all but impossible. So many people 
> on this list with lost metadata, figuring out RAID layout and drive 
> oder is hard, but figuring out random relocations is impossible.

There's no "up" to the existing BBL.  It isn't doing what people think.
It does NOT cause the upper layer to avoid the block address.  It just
kills redundancy at that address.

> The BBL could be improved a lot if it prevented BBLs to be identical 
> across drives, and gave bad blocks a second chance. Once the cable 
> problem is solved, MD should help you turning those bad blocks back 
> into good ones.

MD does exactly this with all modern hard drives using the drives'
built-in relocation systems.  And the write-intent bitmap/re-add feature
helps efficiently deal with writes that were missed on that device while
it was disconnected.

The only thing a BBL could actually help with on modern drives is an
exhausted on-drive relocation table, and only if the BBL was able to do
relocations itself.  Of course, by the time a drive exhausts it internal
spares, it's too far gone to trust anyways.

> And if your drive actually has real bad blocks, the only correct course 
> of action is to replace it entirely.

No, modern drives will attempt to fix blocks on rewrite, and will
relocate them internally if unfixable.  Precisely what you think MD's
BBL should do.  MD's BBL is creating an unfixable mess, not actually
fixing anything.

This is why I suggested using hdparm to pass the BBL data to the
underlying drive.  Then MD *will* actually fix each block.

> The problem with BBL right now is 
> that even if you replace all drives, the BBL stays. Once it's duplicated 
> you are stuck with it forever until you forcibly remove it.

The problem with the BBL right now is its existence.

Phil
