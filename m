From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 read error correction log
Date: Mon, 5 Jun 2006 09:03:38 +1000
Message-ID: <17539.26314.730916.566391@cse.unsw.edu.au>
References: <447FF458.6030802@frameandfocus.com>
	<17536.7877.532121.626175@cse.unsw.edu.au>
	<44821A91.8080007@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Patrik Jonsson on Saturday June 3
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday June 3, patrik@ucolick.org wrote:
> Hey Neil,
> 
> It would sure be nice if the log contained any info about the error
> correction that's been done rather than simply saying "read error
> corrected", like which array chunk, device and sector was corrected. I'm
> having a persistent pending sector on a drive, and when I do check or
> repair, it says "read error corrected" many times, but I don't know
> whether it's doing the same sector over and over or if there are just so
> many of them...  I seem to remember reading something about this on the
> list some time ago, is it already in the kernel? (I'm running 2.6.17-rc4
> now).

Yes.... added to todo list:
   include sector/dev info in read-error-corrected messages

> 
> Btw, when it does correct a read error, I assume it also tries to read
> it again to verify that the correction worked?

Yes.  It doesn't check that the read returns the correct data, but it
does check that a read succeeds.  However I'm not certain that the
read request will punch through any cache on the drive.  It could be
that the reads return data out of the cache without accessing data on
the surface of the disk....

NeilBrown
