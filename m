From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Awful RAID5 random read performance
Date: Sun, 31 May 2009 23:39:11 -0600
Message-ID: <200905312339.12234.tfjellstrom@shaw.ca>
References: <20090601045710141.GMHE24335@cdptpa-omta04.mail.rr.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090601045710141.GMHE24335@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun May 31 2009, Leslie Rhorer wrote:

> >
> > Unfortunately it doesn't seem to be. Take a well-considered drive such
> > as the WD RE3; it's spec for average latency is 4.2ms. However does it
> > include the rotational latency (the time the head takes to reach the
> > sector once it's on the track)? I bet it doesn't. Taking it to be only
> > the average seek time, this drive is still among the fastest. For a
> > 7200rpm drive this latency is just 4.2ms, so we'd have for this fast
> > drive an average total latency of 8.4ms.
>
> That's an average.  For a random seek to exceed that, it's going to have to
> span many cylinders.  Give the container size of a modern cylinder, that's
> a pretty big jump.  Single applications will tend to have their data lumped
> somewhat together on the drive.
>

> >
> > with
> >

> >
> > No, random I/O is the most common case for busy servers, when there
> > are lots of processes doing uncorrelated reads and writes. Even if a
>
> Yes, exactly.  By definition, such a scenario represents a multithreaded
> set of seeks, and as we already established, multithreaded seeks are vastly
> more efficient than serial random seeks.  The 400 seeks per second number
> for 4 drives applies.  I don't know the details of the Linux schedulers,
> but most schedulers employ some variation of an elevator seek to maximize
> seek efficiency.  The brings the average latency way down and brings the
> seek frequency way up.

Ah, I never really understood how adding more random load could increase 
performance. Now I get it :)

> > single application does sequential access the head will likely have
> > moved between them. The only solution is to have lots of ram for
> > cache, and/or lots of disks. It'd be better if they were connected to
> > several controllers...
>
> A large RAM cache will help, but as I already pointed out, the increases in
> returns for increasing cache size diminish rapidly past a certain point.
> Most quality drives these days have a 32MB cache, or 128M for a 4 drive
> array.  Add the Linux cache on top of that, and it should be sufficient for
> most purposes.  Remember, random seeks implies small data extents.  Lots of
> disks will bring the biggest benefit, and disks are cheap.  Multiple
> controllers really are not necessary, especially if the controller and
> drives support NCQ , but having multiple controllers certainly doesn't
> hurt.

Yet I've heard NCQ makes some things worse. Some raid tweaking pages tell you 
to try disabling NCQ.

I've actually been thinking about trying md-cache with an SSD on top of my new 
raid and see how that works long term. But I can't really think of a good 
benchmark that actually imitates my particular use cases well enough to show 
me if it'd help me at all ::)

I doubt my punny little 30G OCZ Vertex would really help all that much any 
how.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
