From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: metadata 1.2 advantages?
Date: Wed, 08 Feb 2012 14:16:21 -0800
Message-ID: <4F32F435.60405@zytor.com>
References: <4F323A00.8050506@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F323A00.8050506@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/08/2012 01:01 AM, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> for now i'm still using grub 0.97 which can only understand metadata
> 0.9. Are there any advantages of the 1.2 metadata format?
> 

There are a lot of advantages to the 1.x metadata format, but 1.0 is the
easiest for bootloaders to deal with.  1.0, 1.1 and 1.2 is the same
format, just with the superblock in different places.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

