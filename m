From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] klibc update
Date: Tue, 16 Mar 2004 14:16:09 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40575279.7040408@pobox.com>
References: <4056B0DB.9020008@pobox.com>	<20040316005229.53e08c0c.akpm@osdl.org>	<20040316153719.GA13723@kroah.com> <20040316111026.6729e153.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040316111026.6729e153.akpm@osdl.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, viro@parcelfarce.linux.theplanet.co.uk, bos@serpentine.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Morton wrote:
> Greg KH <greg@kroah.com> wrote:
> 
>>On Tue, Mar 16, 2004 at 12:52:29AM -0800, Andrew Morton wrote:
>>
>>>It's so long since klibc was discussed (ie: more than five minutes ago)
>>>that I forget the reasons why it should be delivered via the kernel tree.
>>>
>>>Remind me please?
>>
>>We need a way to build the userspace programs that get put into
>>initramfs that will be needed to boot the kernel.
>>
>>That help?
> 
> 
> My grey cells thank you.
> 
> Does klibc have a bk home anywhere, so I can start sucking it in?
> 
> 

There is the one I subtlely posted in my original email :)
	bk://kernel.bkbits.net/jgarzik/klibc-2.5

Bryan O'Sullivan and Greg KH at varying times in the past had BK trees, 
but I didn't know of any up-to-date one.

Note that it isn't my intention to become klibc maintainer...  just in 
case anybody started getting ideas... :)

	Jeff



