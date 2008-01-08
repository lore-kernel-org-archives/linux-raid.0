From: Radu Rendec <radu.rendec@ines.ro>
Subject: Re: Raid 1, new disk can't be added after replacing faulty disk
Date: Tue, 08 Jan 2008 12:38:00 +0200
Message-ID: <1199788680.3202.38.camel@localhost.localdomain>
References: <1199713488.3202.19.camel@localhost.localdomain>
	 <e9c3a7c20801071111t11bdd5fx1b8d59bd0a763c4c@mail.gmail.com>
	 <18306.64884.866266.620787@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18306.64884.866266.620787@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2008-01-08 at 15:35 +1100, Neil Brown wrote:
> On Monday January 7, dan.j.williams@intel.com wrote:
> > On Jan 7, 2008 6:44 AM, Radu Rendec <radu.rendec@ines.ro> wrote:
> > > I'm experiencing trouble when trying to add a new disk to a raid 1 array
> > > after having replaced a faulty disk.
>
> I cannot easily reproduce this.  I suspect it is sensitive to the
> exact size of the devices involved.
> 
> Please test this patch and see if it fixes the problem.

I successfully applied the patch to v2.6.2 and it fixes the problem.
Many thanks for taking the time to look into this issue.

Radu Rendec


