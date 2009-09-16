From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Assemble and Stop array
Date: Wed, 16 Sep 2009 10:06:47 -0500
Message-ID: <20090916150703425.XXDI6569@cdptpa-omta01.mail.rr.com>
References: <816534d7bc3fe604e11760fbf33932d1.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <816534d7bc3fe604e11760fbf33932d1.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > fails with a device busy error.  Every time it has happened, a simple
> > umount
> > command without the -l switch fails, but a "lazy" umount appears to
> work,
> > with the exception that sometimes I still cannot stop the array.
> Clearly,
> > the NFS export is sometimes the culprit, but not always.  What else can
> it
> > be?
> 
> It's best not to use --lazy if yo really want to stop the array.
> It makes it harder to find the problem.

	Well, OK.  I always try an ordinary umount first, but when it fails,
sometimes a lazy umount works.

> You seem to have covered everything that I can think of that would
> keep a filesystem active...
> 
> >
> > 	The second item is assembling an array which was formerly stopped.
> > By my reading, `mdadm --assemble --scan` should work, but it doesn't.
> It
> > keeps telling me no devices are found for the array.  Here is a sample
> > from
> > one of the /etc/mdadm/mdadm.conf files:
> >
> 
> Try adding --verbose to the "mdadm --assemble" line.  If that doesn't
> give you any hints, post the output and it might give me some hints.

	OK, thanks.  The next time it happens, I will.

