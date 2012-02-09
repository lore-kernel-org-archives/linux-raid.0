From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: metadata 1.2 advantages?
Date: Wed, 08 Feb 2012 16:38:08 -0800
Message-ID: <4F331570.7010800@zytor.com>
References: <4F323A00.8050506@profihost.ag> <4F32F435.60405@zytor.com> <20120209105934.36189d93@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120209105934.36189d93@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/08/2012 03:59 PM, NeilBrown wrote:
> On Wed, 08 Feb 2012 14:16:21 -0800 "H. Peter Anvin" <hpa@zytor.com>
> wrote:
> 
>> On 02/08/2012 01:01 AM, Stefan Priebe - Profihost AG wrote:
>>> Hi,
>>> 
>>> for now i'm still using grub 0.97 which can only understand
>>> metadata 0.9. Are there any advantages of the 1.2 metadata
>>> format?
>>> 
>> 
>> There are a lot of advantages to the 1.x metadata format, but 1.0
>> is the easiest for bootloaders to deal with.  1.0, 1.1 and 1.2 is
>> the same format, just with the superblock in different places.
> 
> Hi Peter, wasn't it you who told be that 1.2 was best for boot
> loaders, as 1.0 uses block 0 which the bootloader also wants, while
> 1.2 uses a later block. That is why 1.2 is the default.
> 

No, 1.1 uses block 0 which the bootloader wants.

Bootloaders need no special enabling to support 0.9 or 1.0 RAID-1.
1.2 requires special enabling, but is workable.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

