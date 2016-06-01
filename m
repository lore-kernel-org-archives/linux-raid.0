From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: raid 5 crashed
Date: Wed, 1 Jun 2016 16:42:16 +0100
Message-ID: <574F0258.5000108@youngman.org.uk>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk>
 <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
 <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
 <574C8EB9.3070706@youngman.org.uk>
 <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
 <574D958F.8060209@turmel.org> <574DDCBD.40801@youngman.org.uk>
 <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 01/06/16 02:48, Brad Campbell wrote:
> Now, having said that :
> 
> Much better to try and get the array running in a read-only state with
> all disks in place and clone the data from the array rather than the
> disks after they've been ddrescued. In the case of a running array, a
> read error on one of the array members will see the RAID attempt to get
> the data from elsewhere (a reconstruction), whereas a read from a disc
> cloned with ddrescue will happily just report what was a faulty sector
> as a big pile of zeros, and *poof* your data is gone.
> 
> Set the timeouts appropriately (and conservatively) to give the disks
> time to actually report they can't read the sector. This will allow md
> to try and get it elsewhere rather than kicking the disc out because the
> storage stack timed it out as faulty.

Okay - so would this be better (a lot slower, possibly, but safe ...)

Use dd - so it DOES bomb on error! - and only replace the drive once
you've got a clean read off it. With 2TB drives, that should work so
long as they're not faulty. And if it's - JUST - a timeout issue,
this'll work fine?

Cheers,
Wol
