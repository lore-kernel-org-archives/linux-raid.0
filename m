From: Luca Berra <bluca@comedia.it>
Subject: Re: How to load preexisting ntfs partitions that are on an Intel
	Matrix Raid 1 or 5 ?
Date: Tue, 19 Jan 2010 08:30:06 +0100
Message-ID: <20100119073006.GD2891@maude.comedia.it>
References: <8CC636345AA2F7E-295C-545@webmail-d049.sysops.aol.com> <8CC636C98CCAF21-295C-17C7@webmail-d049.sysops.aol.com> <20100116090848.GA21855@maude.comedia.it> <8CC64CAEA9C15A3-938C-10EBD@webmail-m048.sysops.aol.com> <20100118075315.GB28405@maude.comedia.it> <8CC669D740FEC18-9F4-2D9CA@webmail-d051.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CC669D740FEC18-9F4-2D9CA@webmail-d051.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 18, 2010 at 04:36:39PM -0500, sylarrrrrrr@aim.com wrote:
> Thanks, I will try it.
>
> it being "issuing "dmraid -an" should suffice then just run "mdadm -As"."
>
> However before I will, I would like to know if this is safe?
> Is there a chance that I will lose all my data simply from this and 
> mounting, I ask since it is a new feature.

I was able to use md to access an Intel Matrix raid on my home system,
albeit with some difficulties, due to the fact that the array was
degraded. See the thread titled "imsm woes (and a small bug in mdadm)".
I did not lose any data.
Still my feeling is that mdadm 3.0.3 and 3.1.1 are not complete versus
Intel Matrix. Current git should be much better, or wait for 3.1.2,
around mid-february afaik.
YMMV.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
