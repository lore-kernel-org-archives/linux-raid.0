From: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>
Subject: Re: RAID-related: SATA disk removal?
Date: Sat, 29 Apr 2006 12:29:12 -0300
Message-ID: <200604291229.13247.dvadell@linuxclusters.com.ar>
References: <1146239757.10253.122.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1146239757.10253.122.camel@kenny>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi John,
   I had to do the same some months ago. It turned out that it didn't worked, 
and there was a thread about this here

http://marc.theaimsgroup.com/?l=linux-raid&m=111851721408698&w=2

I will be more than happy to know that it does work for you now with recent 
kernels, but at that time there was still a lot of work to do.

 -- Diego.

On Friday 28 April 2006 12:55, John Rowe wrote:
> I am testing a machine with two SATA drives in startech.com removable
> caddies. Everything including swap is RAID1. (I'm running x86_64
> Scientific Linux 4.2, a RedHat enterprise clone.)
>
> Informal tests suggest that pulling out an active disk causes the whole
> machine to hang up but removing a disk from the RAID arrays and pulling
> it out gives the message: "nv_sata: Primary device removed" and
> everything happily keeps running.
>
> Is this a fair description? In practise do people find that following
> the above allows a failed disk to be replaced without shutting down the
> machine?
>
> Thanks
>
> John
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
