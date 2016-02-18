From: Wolfgang Denk <wd@denx.de>
Subject: Re: swiotlb buffer is full
Date: Thu, 18 Feb 2016 20:44:19 +0100
Message-ID: <20160218194419.E27AA384473@gemini.denx.de>
References: <20160215122539.DC34B3811B2@gemini.denx.de> <20160216201347.GB13119@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20160216201347.GB13119@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Shaohua Li,

In message <20160216201347.GB13119@kernel.org> you wrote:
>
> > I think it is interesting that always the same RAID array gets
> > kicked, and always the same disk.  I cannot see any hardware
> > problems, and a preventive replacement of the disk drive did not fix
> > the problem.
> 
> this doesn't like a md problem.

I tend to agree, but so far I have not found any other test case that
would trigger this problem.

> Probably a dma address leak in the driver. To verify this, you can
> do some IO against the raw disk (sdf/sdg) and check if you see the
> 'swiotlb buffer is full' issue.

At least sequentially reading the drive does not appear to have any
effect; I've completely read it several times with no errors.

> Did you really need iommu, eg if iommu=off works?

This is a good idea; I will enable this setting next time the server
crashed (probably next Sunday night).  but then, is  iommu=off  not
supposed to cause a performance degradation?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Some people march to the beat of a different drummer. And some people
tango!
