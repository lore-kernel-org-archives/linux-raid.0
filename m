From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Proposed enhancements to MD
Date: Fri, 16 Jan 2004 14:56:46 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040116135646.GD27825@marowsky-bree.de>
References: <40033D02.8000207@adaptec.com> <16389.52150.148792.875315@notabene.cse.unsw.edu.au> <20040115155221.A31378@lists.us.dell.com> <20040116092447.GF22417@marowsky-bree.de> <20040116074336.A12893@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040116074336.A12893@lists.us.dell.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Scott Long <scott_long@adaptec.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-01-16T07:43:36,
   Matt Domsch <Matt_Domsch@dell.com> said:

> > Do you know whether DDF can also support simple multipathing?
> Yes, the structure info for each physical disk allows for two (and
> only 2) paths to be represented.  But it's pretty limited, describing
> only SCSI-like paths with bus/id/lun only described in the current
> draft.  At the same time, there's a per-physical-disk GUID, such
> that if you find the same disk by multiple paths you can tell.
> There's room for enhancment/feedback in this space for certain. =20

One would guess that for m-p, a mere media UUID would be completely
enough; one can simply scan where those are found.

If it encodes the bus/id/lun, I can forsee bad effects if the device
enumeration changes because the HBAs get swapped in their slots ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering	      \ ever tried. ever failed. no matt=
er.
SUSE Labs			      | try again. fail again. fail better.
Research & Development, SUSE LINUX AG \ 	-- Samuel Beckett
