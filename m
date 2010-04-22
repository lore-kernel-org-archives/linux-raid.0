From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6 polynomial
Date: Wed, 21 Apr 2010 18:00:34 -0700
Message-ID: <4BCF9FB2.9060505@zytor.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0937604B@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C0937604B@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/19/2010 04:44 PM, Tirumala Reddy Marri wrote:
> What is the default polynomial to calculate RAID-6 syndrome in
> async_pq.c? Is it 0x11d ?

Yes.

	-hpa
