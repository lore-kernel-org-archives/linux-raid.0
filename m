From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Sat, 3 Oct 2009 23:59:33 -0600
Message-ID: <200910032359.33804.tfjellstrom@shaw.ca>
References: <263762.74813.qm@web38801.mail.mud.yahoo.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <263762.74813.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat October 3 2009, adfas asd wrote:
> --- On Sat, 10/3/09, Drew <drew.kay@gmail.com> wrote:
> > From: Drew <drew.kay@gmail.com>
> >
> > > I didn't use LVM, and don't
> >
> > trust layering of any technology.
> >
> > I'm curious as to why you say that?
> >
> > From my experience almost everything in software is layered
> > or an
> > abstraction. The Network & Storage stacks are just
> > layers of code
> > running over top other lower layers. LVM & RAID are
> > just another layer
> > in the storage stack, and well tested ones I might add.
> 
> Feel free.  But the more direct a system, the more reliable it is.  Basic
>  scientific principle.
> 
> To me, LVM just adds a function (expansion) which should be in the RAID
>  module (and likely soon will be), yet adds a whole 'nother layer of
>  complexity.  No thanks.  BTRFS addresses all these issues, but I was an
>  early adopter and got burned by the loss of my data at a crucial point.
> 

It actually adds volumes, something you just don't get with mdraid. Unless you 
count partitions, but that is just.. ew. I had LVM blow up in my face too, but 
it wasn't LVM's fault, it was mine ;) I was the one that was running a "big" 
(for me, at the time) jbod array with no backups. I can hardly blame the loss 
of that data on LVM.

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
