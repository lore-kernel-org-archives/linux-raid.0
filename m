From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] Linux Raid5/6 abover 2 Terabytes
Date: Tue, 4 May 2004 11:24:39 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16534.61655.526793.777576@cse.unsw.edu.au>
References: <249C1CB246997C48BB74963CCD361C1B02376A60@pnlmse28.pnl.gov>
	<1081785234.22588.5.camel@e-linux>
	<40934CD8.3050108@wasp.net.au>
	<1083606555.2494.5.camel@e-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Evan Felix on Monday May 3
To: Evan Felix <evan.felix@pnl.gov>
Cc: Brad Campbell <brad@wasp.net.au>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday May 3, evan.felix@pnl.gov wrote:
> here is the bitkeeper changeset for it, I dont know enough about the
> bitkeeper system to tell if it will be in the next version or not.
> 
> 
> http://linux.bkbits.net:8080/linux-2.5/patch@1.1371.702.338
> 

It is 2.6.6-rc1.  It looks like Davem picked it up.

NeilBrown


> Evan
> 
> On Sat, 2004-05-01 at 00:08, Brad Campbell wrote:
> > Evan Felix wrote:
> > > Niel, did you push this patch to the kernel guys for inclusion in the
> > > next 2.6 kernel?
> > > 
> > > Also by way of status i've built a 5.7Tb SATA array (level 5/6) with
> > > this change in the kernel.
> > > 
> > > so that pushes us to about 4 Arrays now..
> > > 
> > > Evan
> > > 
> > 
> > Has this patch been pushed forwards? It does not appear in 2.6.6-rc3.
> > 
> > Regards,
> > Brad
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
