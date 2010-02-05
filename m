From: Keld Simonsen <keld@keldix.com>
Subject: Re: recovering a mirrored arry.
Date: Fri, 5 Feb 2010 02:19:28 +0100
Message-ID: <20100205011928.GA12630@light.rap.dk>
References: <20100203025758.GA12925@light.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100203025758.GA12925@light.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 03, 2010 at 03:57:58AM +0100, Keld Simonsen wrote:
Hi


can anybody help me with this? I am stuck with recovering my system here.
is it a sensible thing ro do?

best regards
keld

> Hi
> 
> I got 2 arrays in error of the raid10 type.
> 
> I think this is because my motherboard died, and then the fs were
> corrupted.
> 
> My thoughts were that actually one of the copies could be correct.
> So I would like to try out the consistency of each part of the raid10
> (it is 2-partition arrays), and then if I find one that is consistent, then
> resync the faulty one with the good one.
> 
> How do I do this?
> 
> it seems that I cannot just assemble an array with a missing part.
> If I assemble the full array, is there then a risk of the bad one
> corrupting the good one? And can I declare one of the disks faulty
> then test the other one, then declare nbr 2 disk for faulty and 
> declare the first one as good?
> 
> I dont see anything on the wiki on this.
> 
> best regards
> keld
