From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: AW: Raid 5 and Power Failure
Date: Mon, 15 Jul 2002 10:29:18 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15666.5982.13238.264260@notabene.cse.unsw.edu.au>
References: <4D618F6493CE064A844A5D496733D66704DE77@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin Bene on Saturday July 13
To: Martin Bene <martin.bene@icomedias.com>
Cc: Jason Pfingstmann <stclists@wearesimply.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 13, martin.bene@icomedias.com wrote:
> Hi Neil, Jason
> 
> > Get mdadm
> >   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
> > 
> > and use
> >   mdadm --assemble --force /dev/md0 /dev/hd......
> 
> shouldn't /dev/hda be left out of the list here? since it looks like hda
> really is out out date I think you'd get best results by using only the most
> up-to-date disks.

hda certainly could be left out, but the point of "mdadm -Af" is that
it tried to do the "best" thing.  You don't *need* to figure out in
too much detail what has gone wrong.  It will pick the best available
drives and use them.

> 
> Also, when using the mkraid -force method that had to be used before mdadm, I
> always recommended leaving out all spare disks and one of the data disks,
> forcing the array to be (re)created in degraded mode. that way, write
> operations to the disks are kept to a minimum and it's possible to retry if
> you made an error (wrong disk left out etc).
> 
> would it make sense to treat mdadm similarely, i.e only provide enough
> devices to assemble a degraded array and hotadd the final device after the
> array checks out ok? I don't like the idea of background parity rebuild
> kicking in before I've had a chance to check things out.

In general I would agree with that.
I would actually like to be able to start an array in "read-only" mode
and have no rebuild/resync happen until it got switched to write
only.  This may well happen in 2.6.

NeilBrown
