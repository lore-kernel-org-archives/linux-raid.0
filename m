From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Proposed enhancements to MD
Date: Fri, 16 Jan 2004 07:43:36 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040116074336.A12893@lists.us.dell.com>
References: <40033D02.8000207@adaptec.com> <16389.52150.148792.875315@notabene.cse.unsw.edu.au> <20040115155221.A31378@lists.us.dell.com> <20040116092447.GF22417@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040116092447.GF22417@marowsky-bree.de>; from lmb@suse.de on Fri, Jan 16, 2004 at 10:24:47AM +0100
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Scott Long <scott_long@adaptec.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 16, 2004 at 10:24:47AM +0100, Lars Marowsky-Bree wrote:
> Do you know whether DDF can also support simple multipathing?

Yes, the structure info for each physical disk allows for two (and
only 2) paths to be represented.  But it's pretty limited, describing
only SCSI-like paths with bus/id/lun only described in the current
draft.  At the same time, there's a per-physical-disk GUID, such
that if you find the same disk by multiple paths you can tell.
There's room for enhancment/feedback in this space for certain.  

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
