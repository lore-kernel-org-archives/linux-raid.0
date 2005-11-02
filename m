From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: raid0 fail to detect drive failure
Date: Wed, 02 Nov 2005 08:40:47 -0500
Message-ID: <1130938847.9447.111.camel@localhost.localdomain>
References: <1130860974.9447.19.camel@localhost.localdomain>
	 <4368822A.4050400@tls.msk.ru>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4368822A.4050400@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2005-11-02 at 12:08 +0300, Michael Tokarev wrote:
> Ming Zhang wrote:
> > Hi folks
> > 
> > I have a raid0 on top of 2 sata disk sda and sdb. after i hot unplug
> > sda, the raid0 still shows online and active. run dd to write to it will
> > fail and dmesg shows scsi io error. but /proc/mdstat shows everything is
> > ok.
> 
> Since raid0 isn't relly raid (as Redundrand) and can't really do
> anything with IO errors on component devices, this behaviour
> (returning IO errors to the application) is the only sane way
> to go.  It should not fail just like when your disk drive has
> a bad sector on it, the whole partition (or whole disk) with
> that bad sector isn't "marked as failed".  So what you see is
> exactly correct behaviour, in my opinion anyway.
> 
> /mjt

after I sent email, I read the raid0 code and there is no error handling
at all, so i knew why it looks like that. 

for my case, 2 disk raid0, 1 disk broke mean 50% sectors on a disk are
bad. i would like to call that disk a failed disk. and i bet you will
not use such disk any more even you call it not-failed disk. ;)

but as you said, raid0 is not a real raid, so maybe this is why no error
check here.

thanks!

Ming


