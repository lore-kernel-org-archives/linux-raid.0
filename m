From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm --assemble --scan hassles....
Date: Thu, 30 Oct 2003 12:18:44 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16288.26356.482079.504183@notabene.cse.unsw.edu.au>
References: <20031008111709.GV1277@hvs.envisage.co.za>
	<16270.5184.302596.951547@notabene.cse.unsw.edu.au>
	<20031025212433.GE23767@hvs.envisage.co.za>
	<16285.38655.754527.236684@notabene.cse.unsw.edu.au>
	<20031028062445.GD3236@hvs.envisage.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hendrik Visage on Tuesday October 28
To: Hendrik Visage <hvisage@envisage.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 28, hvisage@envisage.co.za wrote:
> On Tue, Oct 28, 2003 at 09:06:55AM +1100, Neil Brown wrote:
> > On Saturday October 25, hvisage@envisage.co.za wrote:
> > > > That would be because mdadm.conf describes /dev/md/1 as:
> > > >     UUID=c2a91233:5ffd5398:eac27773:e12945dd
> > > > but mdadm --examine doesn't show any arrays with that uuid.
> > > > 
> > > > NeilBrown
> > > 
> > > Then how do I fix it??
> > > 
> > 
> > Edit /etc/mdadm.conf
> 
> I've tried without any succes as yet :(
> 
> so what would the correct mdadm.conf look like in my case?
> 

Show me:
 -  your current mdadm.conf
 - the output of mdadm -Es -c partitions
 - the output of mdadm -Ds
 - the output of mdadm -Asv

And I'll try to tell you.

NeilBrown
