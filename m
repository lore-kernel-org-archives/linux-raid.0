From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Re-size RAID-10
Date: Thu, 26 Mar 2009 09:14:18 +0100
Message-ID: <20090326081418.GB23977@rap.rap.dk>
References: <49CAA763.3050405@amfes.com> <18890.44223.469.924083@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18890.44223.469.924083@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Daniel L. Miller" <dmiller@amfes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 26, 2009 at 09:14:22AM +1100, Neil Brown wrote:
> On Wednesday March 25, dmiller@amfes.com wrote:
> > I think I asked this once before, if so I apologize for the redundancy - 
> > but then again maybe something's changed...
> > 
> > I've got a RAID-10 array with four drives.  It's nearing capacity, and I 
> > need to explore expansion options.  Can I simply add a pair of new 
> > drives?  Or do I have to archive the information first and rebuild the 
> > array from scratch?
> 
> It is not currently possible to resize a raid-10.

In my mind, it should not be that difficult, tho, to do it.

Is resize an operation that needs to be done with the fs unmounted?

best regards
keld

