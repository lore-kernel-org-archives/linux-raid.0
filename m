From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux mdadm superblock question.
Date: Mon, 15 Feb 2010 23:02:03 -0800
Message-ID: <4B7A42EB.3070405@zytor.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <20100216112708.4a863f86@notabene.brown> <4B79F3CE.5030907@zytor.com> <alpine.DEB.2.00.1002151916280.5135@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1002151916280.5135@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
To: david@lang.hm
Cc: Neil Brown <neilb@suse.de>, Michael Evans <mjevans1983@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 02/15/2010 07:18 PM, david@lang.hm wrote:
> On Mon, 15 Feb 2010, H. Peter Anvin wrote:
>
>> On 02/15/2010 04:27 PM, Neil Brown wrote:
>>
>> There are three options:
>>
>> a) either don't boot from it (separate /boot);
>> b) use a bootloader which installs in the MBR and
>> hopefully-unpartitioned disk areas (e.g. Grub);
>> c) use a nonstandard custom MBR.
>>
>> Neither (b) or (c), of course, allow for chainloading from another OS
>> install and thus are bad for interoperability.
>
> I have had no problems with XFS partitions and lilo as the bootloader.
> I've been doing this for a couple of years now without realizing that
> there is supposed to be a problem.
>

LILO also can be stuffed in the MBR (and then uses block-pointers from 
there).  There is one more option that I didn't mention, which is to put 
the bootloader of a separate partition, OS/2 style.  Again, breaks the 
standard chainloading model.

	-hpa
