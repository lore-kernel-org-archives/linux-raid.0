From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: raid1 data corruption during resync
Date: Tue, 2 Sep 2014 20:45:16 -0500
Message-ID: <7703179B-1291-4471-B84F-FEE1E28F31A0@redhat.com>
References: <20A5228D-DD63-4A6C-B2C6-B0C38996E636@gmail.com> <EAC50175-42D9-43BA-ADE2-1A50BD0581CB@redhat.com> <18B7DF88-26D1-44B8-8F72-2159A2DF868D@gmail.com> <20140903095507.032e8c6d@notabene.brown> <F9B1D613-79EF-488E-8D41-4C1BDBC6D4BE@redhat.com> <20140903113151.4099292b@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140903113151.4099292b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Eivind Sarto <eivindsarto@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sep 2, 2014, at 8:31 PM, NeilBrown wrote:

> Thanks for the details Jon.  I don't suppose you have a stack trace from an
> upstream kernel?  Not that I doubt you have one, and I suspect it is very
> similar.  But I've learnt not to trust "suspect" and "presume" and "no doubt".
> 
> I'll have a look anyway.

Indeed - me too.  I'll get started on recreating it on the latest upstream kernel now.  It does take several hours to reproduce on average, so I likely won't send the update until tomorrow.

 brassow

