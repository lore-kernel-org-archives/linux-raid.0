From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: On the subject of RAID-6 corruption recovery
Date: Fri, 04 Jan 2008 17:49:19 -0800
Message-ID: <477EE21F.4070505@zytor.com>
References: <4774663C.5090609@zytor.com>       <59840.88.217.65.202.1199491167.squirrel@www.e18.physik.tu-muenchen.de>       <477EC96D.80505@zytor.com>    <51481.88.217.65.202.1199493668.squirrel@www.e18.physik.tu-muenchen.de>    <477ED321.6000708@zytor.com> <58669.88.217.65.202.1199496331.squirrel@www.e18.physik.tu-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58669.88.217.65.202.1199496331.squirrel@www.e18.physik.tu-muenchen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thiemo Nagel wrote:
> 
> That's why I was asking about the generator.  Theoretically, this
> situation might be countered by using a (pseudo-)random pattern of
> generators for the different bytes of a sector, though I'm not sure
> whether it is worth the effort.
> 

Changing the generator is mathematically equivalent to changing the 
order of the drives, so no, that wouldn't help (and would make the 
common computations a lot more expensive.)

	-hpa
