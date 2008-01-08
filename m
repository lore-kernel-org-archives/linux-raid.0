From: Radu Rendec <radu.rendec@ines.ro>
Subject: Re: Raid 1, new disk can't be added after replacing faulty disk
Date: Tue, 08 Jan 2008 12:24:22 +0200
Message-ID: <1199787862.3202.35.camel@localhost.localdomain>
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
> > Looks like you are running into the issue described here:
> > http://marc.info/?l=linux-raid&m=119892098129022&w=2

Dan, thanks for your quick reply. It's exactly the same issue: the array
was created with mdadm 2.5.6.

> I cannot easily reproduce this.  I suspect it is sensitive to the
> exact size of the devices involved.

I reproduced this with 3 different device sizes: 518160384 bytes,
4005711360 bytes and 155021851648 bytes. Is it possible that I hit the
"wrong" size every time? Maybe it's related to the disk geometry
(because all partitions lay on exact cylinder boundaries, and thus all
partitions sizes are multiples of the same cylinder size).

> Please test this patch and see if it fixes the problem.
> If not, please tell me the exact sizes of the partition being used
> (e.g. cat /proc/partitions) and I will try harder to reproduce it.

I'll test the patch and get back to you soon.

Thanks,

Radu Rendec


