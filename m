From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 01:56:18 +0100
Message-ID: <200501090156.18658.maarten@ultratux.net>
References: <200501082309.j08N9t911087@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501082309.j08N9t911087@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 09 January 2005 00:09, Guy wrote:
> Maarten said:
> "Normally, the minute a drive fails, it gets kicked and the spare would
> kick in and md syncs this spare.  We now have a non-degraded array again."
>
> Guy says:
> But, you make it seem instantaneously!  The array will be degraded until
> the re-sync is done.  In my case, that takes about 60 minutes, so 1 extra
> minute is insignificant.

No, sure it is not instantaneous, far from it. Sorry if I made that 
impression.  On my system it takes a whole lot longer than 60 minutes, more 
like 360 minutes.  (in my other array where I use whole-disk 160 GB volumes).

> Marrten said:
> "Yes, but this would be impossible to do, since md cannot anticipate
> _which_
> disk you're going to fail before it happens. ;)"
>
> Guy says:
> But, I could tell md which disk I want to spare.  After all, I know which
> disk I am going to fail.  Maybe even an option to mark a disk as "to be
> failed", which would cause it to be spared before it goes off-line.  Then
> md could fail the disk after it has been spared.  Neil, add this to the
> wish list!  :)

Yes, that would be a smart option indeed :)  It gets rid of the window where 
any failure would be fatal.  But I suppose Neil is overworked as it is.

> EMC does this on their big iron.  If the system determines a disk is having
> too many issues (bad blocks or whatever), the system predicts a failure,
> the system copies the disk to a spare.  That way a second failure during
> the re-sync would not be fatal.  And a direct disk to disk copy is much
> faster (or easier) than a re-build from parity.  This is how it was
> explained to me about 5 years ago.  No idea if it was marketing lies or
> truth.  But I liked the fact that my data stayed redundant while the spare
> was being re-built. This would not work if a drive failed, only if a drive
> failure was predicted.  Another cool feature... the disk array then makes a
> support call.  The disk is replaced quickly, normally before any redundancy
> was lost.

Hehe.  Cool.  Big iron -> You indeed get what ya pay for :-))



