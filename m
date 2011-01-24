From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Mon, 24 Jan 2011 21:48:27 +0100
Message-ID: <20110124204827.B707FB187@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de> <4D361F26.3060507@stud.tu-ilmenau.de> <20110119192104.1FA92D30267@gemini.denx.de> <AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com> <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Dear Justin Piszcz,

In message <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan> you wrote:
>
> > So, you may need to benchmark fs part.
> 
> Some info on XFS benchmark with delaylog here:
> http://comments.gmane.org/gmane.comp.file-systems.xfs.general/34379

Thanks a lot for the pointer. I will try this out.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Madness takes its toll. Please have exact change.
