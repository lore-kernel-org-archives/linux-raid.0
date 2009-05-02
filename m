From: "NeilBrown" <neilb@suse.de>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Sun, 3 May 2009 08:41:49 +1000 (EST)
Message-ID: <a960aae116852f769f6e223581fa6835.squirrel@neil.brown.name>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
    <18922.50050.860008.242658@notabene.brown>
    <slrnguupf4.911.Mario.Holbe@darkside.dyn.samba-tng.org>
    <slrngve39c.8a2.Mario.Holbe@darkside.dyn.samba-tng.org>
    <18938.23135.726382.733302@notabene.brown>
    <20090501175524.GA8163@darkside.22.kls.lan>
    <fb9dbbffc38b437042076747a41ddf9b.squirrel@neil.brown.name>
    <20090502195259.GA8499@darkside.22.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090502195259.GA8499@darkside.22.kls.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 3, 2009 5:52 am, Mario 'BitKoenig' Holbe wrote:
> I guess, there is something else going wrong here. I attached a (quite
> large, sorry for that) transcript of what I was doing with the output of
> what I think could help.
>
> What I did:
> * I had a stable and clean raid10 out of 6 disks with superblocks all
>   uptodate, on-disk bitmaps all uptodate.
> * I failed and removed 3 of the disks.
> * I set some bits in the bitmap via mounting/umounting the raid10.
> * I stopped the raid10 just to make sure all superblocks/bitmaps are
>   uptodate.
> * I assembled the raid10 again with 3 out of 6 devices now.
> * I re-added the 3 missing disks.
>   Please note, that I cannot add them all at the same time because if
>   the array is read-write the resync starts immediately when the first
>   device is added, while I cannot add devices as long as the array is
>   read-only.
>   In this immediately starting re-sync only the first of the three
>   spares is synched, it seems to ignore the bitmap, and it generates
>   I/O all the time, I just forgot to c'n'p the evidence. I have seen
>   that 3 times now with iostat, it really does I/O.
> * I stopped and started the array to make it resync over all 3 spares
>   concurrently, it seems to ignore the bitmap, and it generates I/O
>   all the time again.

I managed to reproduce this thanks to all the detail you provided.
The problem was caused by trying to add a device to the array while the
array was readonly.
mdadm attempts a re-add.  When this fails it tries a conventional add
which involves writing  new metadata which shows the device to be a
spare.  That causes the information that would allow the fast resync
to be destroyed.

Can you duplicated the problem without setting the array to readonly?

The next mdadm release will check for EROFS from the re-add attempt and
not attempt the conventional add, thus saving the metadata.

Yes, it would be nice to be able to add multiple devices at once.
Maybe I could just get the kernel to wait 100ms after an add before
starting recovery in case a second device is about to be added.
I'll give it some thought.

NeilBrown

