From: Tide <lovetide@qq.com>
Subject: Re: Array created by mdadm 3.2 & 3.3 have different array size, why?
Date: Wed, 26 Mar 2014 19:47:55 +0000 (UTC)
Message-ID: <loom.20140326T204008-573@post.gmane.org>
References: <tencent_66C345191B9B49B92956F243@qq.com> <5333160F.8060007@SGI.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Larry Fenske <LFenske <at> SGI.com> writes:

> 
> Your RAID 6 array has an internal bitmap, while your RAID 5 array does not.

When creating array, I didn't specified bitmap options (don't know what it
is), so is it different behavior between v3.2 and v3.3, or it's just the 
compile parameters are different between CentOS 6 and Fedora 19/20?

> 
> - Larry Fenske
> SGI signature
> 
> Senior Software Engineer
> SGI
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 




