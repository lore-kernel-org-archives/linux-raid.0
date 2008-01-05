From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: On the subject of RAID-6 corruption recovery
Date: Fri, 04 Jan 2008 16:03:57 -0800
Message-ID: <477EC96D.80505@zytor.com>
References: <4774663C.5090609@zytor.com> <59840.88.217.65.202.1199491167.squirrel@www.e18.physik.tu-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59840.88.217.65.202.1199491167.squirrel@www.e18.physik.tu-muenchen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thiemo Nagel wrote:
> 
> Inverting your argumentation, that means when we don't see z >= n or
> inconsistent z numbers, multidisc corruption can be excluded statistically.
> 
> For errors occurring on the level of hard disk blocks (signature: most
> bytes of the block have D errors, all with same z), the probability for
> multidisc corruption to go undetected is ((n-1)/256)**512.  This might
> pose a problem in the limiting case of n=255, however for practical
> applications, this probability is negligible as it drops off
> exponentially with decreasing n:
> 

That assumes fully random data distribution, which is almost certainly a 
false assumption.

	-hpa
