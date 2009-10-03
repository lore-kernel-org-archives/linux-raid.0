From: adfas asd <chimera_god@yahoo.com>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Sat, 3 Oct 2009 14:09:42 -0700 (PDT)
Message-ID: <263762.74813.qm@web38801.mail.mud.yahoo.com>
References: <c268e4660910031205k5b79836dy55a0c39539f5c14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660910031205k5b79836dy55a0c39539f5c14@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



--- On Sat, 10/3/09, Drew <drew.kay@gmail.com> wrote:

> From: Drew <drew.kay@gmail.com>
> > I didn't use LVM, and don't
> trust layering of any technology.
> 
> I'm curious as to why you say that?
> 
> From my experience almost everything in software is layered
> or an
> abstraction. The Network & Storage stacks are just
> layers of code
> running over top other lower layers. LVM & RAID are
> just another layer
> in the storage stack, and well tested ones I might add.

Feel free.  But the more direct a system, the more reliable it is.  Basic scientific principle.  

To me, LVM just adds a function (expansion) which should be in the RAID module (and likely soon will be), yet adds a whole 'nother layer of complexity.  No thanks.  BTRFS addresses all these issues, but I was an early adopter and got burned by the loss of my data at a crucial point.



      
