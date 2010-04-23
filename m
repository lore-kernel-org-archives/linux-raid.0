From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: RAID-6 polynomial
Date: Thu, 22 Apr 2010 21:14:15 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C09439F92@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0937604B@SDCEXCHANGE01.ad.amcc.com> <4BCF9FB2.9060505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <4BCF9FB2.9060505@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




-----Original Message-----
From: H. Peter Anvin [mailto:hpa@zytor.com] 
Sent: Wednesday, April 21, 2010 6:01 PM
To: Tirumala Reddy Marri
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID-6 polynomial

On 04/19/2010 04:44 PM, Tirumala Reddy Marri wrote:
> What is the default polynomial to calculate RAID-6 syndrome in
> async_pq.c? Is it 0x11d ?
>
>Yes.
>
>	-hpa
>
----

Is there a reason for hard coding 0x11d as polynomial ? The problem I
ran into was when  I was trying disk fail test there was issue in
recovering the data. Then it turned out to be ADMA was using polynomial
0x14d and SW algorithm was using 0x11d. This was because syndrome
calculated using DMA engine and recovery done using SW api.

