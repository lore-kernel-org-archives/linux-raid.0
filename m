From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: replace disk in raid5 without linux noticing?
Date: Wed, 19 Apr 2006 13:03:42 -0400
Message-ID: <1145466223.8608.84.camel@localhost.localdomain>
References: <200604191631.04305.Dexter.Filmore@gmx.de>
	 <e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shai <shaibn@gmail.com>
Cc: Dexter Filmore <Dexter.Filmore@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2006-04-19 at 18:31 +0200, Shai wrote:
> On 4/19/06, Dexter Filmore <Dexter.Filmore@gmx.de> wrote:
> > Let's say a disk in an array starts yielding smart errors but is still
> > functional.
> > So instead of waiting for it to fail completely and start a sync and stress
> > the other disks, could I clone that disk to a fresh one, put the array
> > offline and replace the disk?
> 
> Hi,
> 
> Why can't you just mark that drive as failed, remove it and hotadd a
> new drive to replace the failed drive?

because background rebuild is slower than disk to disk copy, since his
disk is still fully functional.


> 
> Shai
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

