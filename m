From: "Richard B. Johnson" <root@chaos.analogic.com>
Subject: Re: RAID backup
Date: Fri, 4 Oct 2002 11:13:17 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.95.1021004105324.521A-100000@chaos.analogic.com>
References: <3D9DA67A.8050608@comedia.it>
Reply-To: root@chaos.analogic.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D9DA67A.8050608@comedia.it>
To: Luca Berra <bluca@comedia.it>
Cc: "Dr. David Alan Gilbert" <gilbertd@treblig.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 4 Oct 2002, Luca Berra wrote:

> Dr. David Alan Gilbert wrote:
> > * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > 
> >>The problem with disks is you still have to archive them somewhere, and
> >>they are bulky. I also dont know what studies are available on the
> >>degradation of stored disk media over time. 
> > 
> > 
> > Not sure about that; DLT tapes are pretty bulky themselves; I think the
> > difference between say a set of 4 DLT tapes and a single Maxtor 320 in
> > caddy would be minimal. As for stored media, I think Maxtor are quoting
> > 1M hours MTTF - (I hate to think how you measure such a figure) - for
> > the 320G, and that is probably longer than I'd trust either the tape or
> > the drive to survive.
> 
> i DO seriously doubt that this figure includes removing the drive, 
> stuffing it in a siutcase or similar, loading on a truck/car/bike and 
> unloading at a remote site.
> 
> Regards,
> L.

Fire-wire 80 GB external drives work fine for this (Maxtor and others).
Keep them in a cool, not too dry (30 - 50 % RH), area. After a year or
two, they may take several power-cycles to start them up. You should
store them on an edge. This helps keep lube from weeping from the
sintered-bronze (Oilite) bearing, onto the platters.

Electronics that contain electrolytic capacitors shouldn't be stored
where the RH is below 10 % (either should tapes). The platters of
these disk-drives are in an environment where air-pressure can equalize
so they are not really "sealed". Instead, any air entering gets filtered.
Therefore, keep them away from things that leak nasty vapors like
batteries, paint, and fuels.

I've tried for years to find tape-drives that can reliably restore
backed-up data. Once you get to multi- Gigabyte drives, you can just
forget it. The data reliability necessary to read through 80 or more
gigibytes of data (serially) with no errors, to get to the file you need,
is just not available in any drive I've tested including the newest Sony
DLT.

The Linux SCSI tape driver will not attempt to read past a "permanent"
error. In principle, it could find the next tape-mark, then continue,
but it doesn't. Once an error occurs that the drive can't electronically
correct, that's all she wrote. It's not like a disk where you can just
tell some software layer to never read a bad "sector" again.

Cheers,
Dick Johnson
Penguin : Linux version 2.4.18 on an i686 machine (797.90 BogoMips).
The US military has given us many words, FUBAR, SNAFU, now ENRON.
Yes, top management were graduates of West Point and Annapolis.

