From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: When does a disk get flagged as bad?
Date: Wed, 30 May 2007 21:49:02 -0500
Message-ID: <1180579742.20508.18.camel@w100>
References: <5822.1180578498@mdt.dhcp.pit.laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5822.1180578498@mdt.dhcp.pit.laurelnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2007-05-30 at 22:28 -0400, Mike Accetta wrote:
> Alberto Alonso writes:
> > OK, lets see if I can understand how a disk gets flagged
> > as bad and removed from an array. I was under the impression
> > that any read or write operation failure flags the drive as
> > bad and it gets removed automatically from the array.
> > 
> > However, as I indicated in a prior post I am having problems
> > where the array is never degraded. Does an error of type:
> > end_request: I/O error, dev sdb, sector ....
> > not count as a read/write error?
> 
> I was also under the impression that any read or write error would
> fail the drive out of the array but some recent experiments with error
> injecting seem to indicate otherwise at least for raid1.  My working
> hypothesis is that only write errors fail the drive.  Read errors appear
> to just redirect the sector to a different mirror.
> 
> I actually ran across what looks like a bug in the raid1
> recovery/check/repair read error logic that I posted about
> last week but which hasn't generated any response yet (cf.
> http://article.gmane.org/gmane.linux.raid/15354).  This bug results in
> sending a zero length write request down to the underlying device driver.
> A consequence of issuing a zero length write is that it fails at the
> device level, which raid1 sees as a write failure, which then fails the
> array.  The fix I proposed actually has the effect of *not* failing the
> array in this case since the spurious failing write is never generated.
> I'm not sure what is actually supposed to happen in this case.  Hopefully,
> someone more knowledgeable will comment soon.
> --
> Mike Accetta

I was starting to think that nobody got my posts, I know there
are plenty of people that understand raid and didn't get any answers
to any of my related posts.

After thinking about your post, I guess I can see some logic behind
not failing on the read, although I would say that after x amount of
read failures a drive should be kicked out no matter what.

In my case I believe the errors are during writes, which is still
confusing.

Unfortunately I've never done any kind of disk I/O code so I am
afraid of looking at the code and getting completely lost.

Alberto

