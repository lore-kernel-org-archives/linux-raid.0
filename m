From: Louis-David Mitterrand <vindex@apartia.org>
Subject: Re: strange lilo error
Date: Wed, 16 Jun 2004 09:53:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040616075353.GD11581@apartia.fr>
References: <20040615073953.GA25753@apartia.fr> <cambq6$pae$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cambq6$pae$1@sea.gmane.org>
To: Mario 'BitKoenig' Holbe <Mario.Holbe@RZ.TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 15, 2004 at 10:25:42AM +0200, Mario 'BitKoenig' Holbe wrote:
> Louis-David Mitterrand <vindex@apartia.org> wrote:
> > Once /dev/hdb1 and /dev/hdb2 have been marked faulty and removed lilo
> > will fail with the following message:
> > Fatal: Trying to map files from unnamed device 0x0000 (NFS/RAID mirror down ?)
> 
> Well, this is coherent, isn't it?

No, this doesn't happen with a 2.4.26 kernel, only with a 2.6.6 (and
maybe others in the 2.6.x series).

> > After running a few tests it appears lilo will only stop complaining
> > once the original raid1 set is restored _and_ synchronized.
> [...]
> > Any idea? Thanks in advance,
> 
> Well, a question at first :)
> Why do you need to run lilo after you failed one of the mirrors?

I need to reboot to a degraded array to complete the filesystem
conversion.

> Anyways - I'm running lilo on degraded arrays and it works
> very well.

On which kernel?

-- 
 "When I give food to the poor I am called a saint, when I ask why
  they go hungry I am called a communist"
   --Bishop Helder Camara
