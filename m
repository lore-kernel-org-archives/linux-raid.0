From: Luca Berra <bluca@comedia.it>
Subject: Re: raid and power off savety
Date: Wed, 23 Mar 2005 21:12:18 +0100
Message-ID: <20050323201218.GC26683@percy.comedia.it>
References: <76592C4D3DA1AC4FB8424084D10D31A806115268@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <76592C4D3DA1AC4FB8424084D10D31A806115268@mchh2c4e.mchh.siemens.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 22, 2005 at 12:29:57PM +0100, Schuett Thomas EXT wrote:
Define RAID,
I will answer for RAID = MD driver, but hw raid solutions might have
different answers (eg battery backed up cache)

>If you think through system crash scenarios, what types of chrashes 
>are you are thinking of? Do you only consider harddisk faults, or 
>do you consider power failures as well?
md protects against disk failures

>Or more extreme: Does RAID gives you savety on HD HW failures, but may
>make things worse for power failures (hard power switch off)?
a power failure _might_ make things worse

>Or more academic: Does raid have some journaling of its dirty cache 
>(and/or whatever would need to be journaled) in a non volatile way,
>or isn't there any need for it for any tricky reason?
there isn't one for lack of a non-volatile storage for dirty cache

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
