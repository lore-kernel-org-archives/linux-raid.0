From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Proposed enhancements to MD
Date: Fri, 16 Jan 2004 14:06:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040116140615.A24102@infradead.org>
References: <40033D02.8000207@adaptec.com> <16389.52150.148792.875315@notabene.cse.unsw.edu.au> <20040115155221.A31378@lists.us.dell.com> <20040116092447.GF22417@marowsky-bree.de> <20040116074336.A12893@lists.us.dell.com> <20040116135646.GD27825@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040116135646.GD27825@marowsky-bree.de>; from lmb@suse.de on Fri, Jan 16, 2004 at 02:56:46PM +0100
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Neil Brown <neilb@cse.unsw.edu.au>, Scott Long <scott_long@adaptec.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 16, 2004 at 02:56:46PM +0100, Lars Marowsky-Bree wrote:
> If it encodes the bus/id/lun, I can forsee bad effects if the device
> enumeration changes because the HBAs get swapped in their slots ;-)

A bus/id/lun enumeration is completely bogus.  Think (S)ATA, FC or
iSCSI.

So is there a pointer to the current version of the spec?  Just reading
these multi-path enumerations start to give me the feeling this spec
is designed rather badly..
