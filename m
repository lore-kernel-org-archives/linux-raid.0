From: Keld J?rn Simonsen <keld@dkuug.dk>
Subject: Re: southbridge/sata controller performance?
Date: Mon, 5 Jan 2009 17:11:47 +0100
Message-ID: <20090105161147.GA9561@rap.rap.dk>
References: <20090103193429.GA17462@sewage.raw-sewage.fake> <495FC67A.2030201@gmail.com> <alpine.DEB.1.10.0901040451520.18797@p34.internal.lan> <20090104194023.GB10174@sewage.raw-sewage.fake> <496123ED.5050809@gmail.com> <20090105032728.GA24328@sewage.raw-sewage.fake> <20090105070806.GA3910@rap.rap.dk> <20090105142120.GA963@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090105142120.GA963@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 05, 2009 at 08:21:20AM -0600, Matt Garman wrote:
> On Mon, Jan 05, 2009 at 08:08:07AM +0100, Keld J?rn Simonsen wrote:
> > What about CPU usage?
> 
> I didn't watch that while running the test, but I can certainly
> re-run them.  Is watching top the best way measure CPU usage, or is
> there a better/more precise (and scriptable) way to capture CPU
> usage for a process or group of processes?

I would  use iostat on a reasonably otherwise quiet system.

> > What happens when you put it into one or more raids, what are then
> > your combinde performance? Did you experiment with different raid
> > types?
> 
> I was only doing read tests at the raw sata device level, so the
> actual raid shouldn't have made a difference.  Although as an
> afterthought I realized could run the script at the md-device level.
> 
> Plus, I have semi-valuable data on these raids, and don't want to go
> messing with them at this point!  :)

I see. It is just that your choice of raid could affect the performance
and thus the need for southbridge bandwidth. Anyway it would be
interesting to see how much you could get out of your system with a live
fs.

best regards
keld
