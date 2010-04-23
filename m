From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6 polynomial
Date: Thu, 22 Apr 2010 22:43:57 -0700
Message-ID: <4BD1339D.3040506@zytor.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0937604B@SDCEXCHANGE01.ad.amcc.com> <4BCF9FB2.9060505@zytor.com> <AC5E1C3367E37D44970B81A6ADD1DA2C09439F92@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C09439F92@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/22/2010 09:14 PM, Tirumala Reddy Marri wrote:
> 
> Is there a reason for hard coding 0x11d as polynomial ? The problem I
> ran into was when  I was trying disk fail test there was issue in
> recovering the data. Then it turned out to be ADMA was using polynomial
> 0x14d and SW algorithm was using 0x11d. This was because syndrome
> calculated using DMA engine and recovery done using SW api.
> 

Yes, it would mean the on-disk format would be incompatible otherwise.
Everyone needs to use the same polynomial.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

