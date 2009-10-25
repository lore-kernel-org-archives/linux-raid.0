From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 23:26:07 -0600
Message-ID: <200910242326.07365.tfjellstrom@shaw.ca>
References: <20091025023059520.QFQH17264@cdptpa-omta04.mail.rr.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091025023059520.QFQH17264@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat October 24 2009, Leslie Rhorer wrote:
> > On Sat, Oct 24, 2009 at 6:52 PM, Leslie Rhorer <lrhorer@satx.rr.com>
> >
> > wrote:
> > >> I'm going to go on a limb here and say for anyone (with data they want
> > >> to preserve), no matter what, backups make sense and are cost
> > >> effective. I'm going to be crazy and say that there's no reason that
> > >> someone who thinks they can afford a 8TB disk array and dual SLI video
> > >> cards, etc, etc, can't also consider some sort of disk or tape backup.
> > >
> > >        I agree with the disk backup, but not the tape.
> > >
> > >> Cumbersome? Can be. But having worked with datasets and filesystems
> > >
> > >        Cumberesome, slow, kludgy, and expensive.
> >
> > Well, like anything else, having a system helps. And by system I mean
> > a library, barcodes on all tapes, and a good tape storage system. Yes,
> > it involves Humans.
> 
> 	Well, that wasn't quite my point, but it is another aspect of the
> issue.
> 
> > >> that run into the hundreds of terabytes, and having backed them up to
> > >> tape, it makes sense. If you have something on the order of tens of
> > >> disks, sure, go ahead, take that next step and back them up somewhere
> > >> else to another set of disks. If you have more disks, seriously
> > >> consider tape--in terms of capacity and power consumption (and data
> > >> integrity), tape wins.
> > >
> > >        Power consumption, yes.  Capacity is a somewhat more complex
> > > problem, with a number of variables.  For speed, tapes lose
> >
> > disastrously.
> >
> > > For cost, hard drives win unless the array is very large.  For
> >
> > reliability
> >
> > > and availability, drives win hands down.  I've had quite a bit of data
> >
> > lost
> >
> > > with bad tape sets, and the most persistent problems on my systems
> > > which
> >
> > do
> >
> > > use tapes involve the tape drives, even sans data loss.  Once someone
> >
> > wiped
> >
> > > out a directory which someone up in corporate was backing up to tape.
> >
> >  It
> >
> > > took 3 days to recover the directory, no doubt because no one could
> > > find
> >
> > the
> >
> > > tape.
> >
> > I'm not so sure about the speed--you can stream 100MB/sec to a single
> > tape drive, and if you have multiple in a library, it just scales
> > horizontally.
> 
> 	First of all, that assumes the tape is loaded and ready.  It can
> take hours or even days to retrieve a tape and load it.  Secondly, while
>  the tape can stream 100MB/sec, it isn't random access.  Finding a 200 byte
>  file in the middle of a 1T tape backup is going to take a while.  Getting
>  it from an online backup server takes perhaps 10ms after the admin
>  finishes typing the copy command.

Wouldn't you use some 'tar' like format on the tape so there's a file index 
you can search without having to scan the entire tape? Then you can just 
"ffwd" (seek) to the position. _should_ be lots faster than reading all of the 
data from the beginning to the files location trying to find it. Or maybe 
there's something I'm missing about tapes?

> > But, where I was working, we were also duplicating tape sets for
> > offsite, which means there was two copies per backup set.
> >
> > Is this expensive? You betcha! But...you know. The bad old days of DDS
> > are also gone, so there's some rejoicing there.
> 
> 	They may be for you.  I have to manage over 300 of the beasts on the
> same number of hosts.  What's worse, not only are the backups themselves
> often incompatible, the drives often can't even use the same tapes.  I have
> to see to it a half dozen different tape types get stocked in 75 different
> cities.  Then I have to try to make sure the gopher in every city remembers
> to replace the tape.

:(

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
