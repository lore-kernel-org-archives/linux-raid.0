From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: Mirroring swap
Date: Thu, 26 Jun 2003 10:30:03 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030626073003.GJ28900@mea-ext.zmailer.org>
References: <Pine.LNX.4.44.0306251535120.16603-100000@gpu.utcc> <BKEGKPICNAKILKJKMHCAEEFPEHAA.Riley@Williams.Name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BKEGKPICNAKILKJKMHCAEEFPEHAA.Riley@Williams.Name>
To: Riley Williams <Riley@Williams.Name>
Cc: Derek Yeung <dky@utcc.utoronto.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 26, 2003 at 08:07:47AM +0100, Riley Williams wrote:
> Hi Derek.
>  > I'm running Red Hat 9 on stock kernel 2.4.20 with software
>  > RAID 1.
>  >
>  > I was wondering if it's a good idea to also mirror the swap
>  > partition? I was reading old posts in the newsgroups that
>  > suggest this may not be a good idea but I can't seem to find
>  > an answer as to why. I think mirroring swap would be a good
>  > idea as it would increase redundancy. Any thoughts?  
> 
> Personally, I can't see the point. the contents of swap are by
> definition short term temporary data with copies held either in
> memory or elsewhere on the hard disk subsystem.

I do that mirroring routinely.

What Linux sends to swap has _no_ origin in anywhere else in
the system, e.g. shared library loading makes runtime modifications
into loaded program, modifications to RW DATA segment, and
of course the BSS segment, and all of heap, and stack...

Most of the executable will usually stay unmodified, and be
backed by its on-disk version, but never everything.

...
> Remember that using a raided swap partition means that the swap
> code has no idea which drive any particular part of that swap
> partition is on, so could result in the swap copy being on the
> same failed drive as the original copy.

Nope.  swap-code does not see it at all.  All of that is hidden with
under the mirroring code, and it does disconnect faulted drive from
the mirror set.

> Best wishes from Riley.

/Matti Aarnio
