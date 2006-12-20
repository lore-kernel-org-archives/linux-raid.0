From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: [solved] supermicro failure
Date: Wed, 20 Dec 2006 07:59:02 +0100
Message-ID: <20061220065902.GA5808@apartia.fr>
References: <20061109141811.GA5805@apartia.fr> <20061109142731.GA9713@apartia.fr> <20061109144303.GA6228@apartia.fr> <4588B251.9000807@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4588B251.9000807@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 19, 2006 at 10:47:29PM -0500, Bill Davidsen wrote:
> Louis-David Mitterrand wrote:
> >On Thu, Nov 09, 2006 at 03:27:31PM +0100, Louis-David Mitterrand wrote:
> >  
> >>I forgot to add that to help us solve this we are ready to hire a paid 
> >>consultant please contact me by mail or phone at +33.1.46.47.21.30
> >>    
> >
> >Update: we eventually succeded in reassembling the partition, with two 
> >missing disks.
> 
> Your update would be far more interesting if you found out why it 
> ejected three drives at once... The obvious common failures, controller 
> and power supply would not prevent reassembly in a functional environment.

Actually the motherboard and/or its on-board scsi controller turned out 
defective. Reassembly succeded once the disk were transfered to another 
box.

Has anyone seen such hardware failure on a brand new SuperMicro machine?

Thanks,
