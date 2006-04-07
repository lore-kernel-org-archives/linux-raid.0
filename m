From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Real Time Mirroring of a NAS
Date: Fri, 7 Apr 2006 19:29:49 +0300
Message-ID: <5b170a7d0604070929r781f0fdcqdd0a7c643ca490b5@mail.gmail.com>
References: <44364336.7060704@aol.com>
	 <Pine.LNX.4.62.0604070703560.27432@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0604070703560.27432@chaos.egr.duke.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: andy liebman <andyliebman@aol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I'm looking for a way to create a real-time mirror of a NAS. In other words,
> > say I have a 5.5 TB NAS (3ware 16-drive array, RAID-5, 500 GB drives). I want
> > to mirror it in real time to a completely separate 5.5 TB NAS. RSYNCing in
> > the background is not an option. The two NAS boxes need to hold identical
> > data at all times. It is NOT necessary that the data be accessed from both
> > NAS boxes simultaneously. One is simply a backup of the other.
> >
> I don't have any experience with it, but I've often seen DRBD mentioned
> for just this sort of situation.  I'd look into that.
>

Linux NBD (and md on top) is a simpler solution for the same thing.
I'd look into that also :)
