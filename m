From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] klibc update
Date: Tue, 16 Mar 2004 14:32:01 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <40575631.1080006@pobox.com>
References: <4056B0DB.9020008@pobox.com> <20040316005229.53e08c0c.akpm@osdl.org> <20040316153719.GA13723@kroah.com> <20040316111026.6729e153.akpm@osdl.org> <40575279.7040408@pobox.com> <20040316192458.GB21172@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040316192458.GB21172@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, viro@parcelfarce.linux.theplanet.co.uk, bos@serpentine.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg KH wrote:
> On Tue, Mar 16, 2004 at 02:16:09PM -0500, Jeff Garzik wrote:
> 
>>Bryan O'Sullivan and Greg KH at varying times in the past had BK trees, 
>>but I didn't know of any up-to-date one.
> 
> 
> I think Bryan was trying to keep his bk tree up to date with the klibc
> cvs tree, but don't know how well that went.

The latest I found from bos was 2.6.0-test9, not terribly ancient but 
still required some hand-fixing of merge conflicts.


>>Note that it isn't my intention to become klibc maintainer...  just in 
>>case anybody started getting ideas... :)
> 
> 
> I thought hpa was the klibc maintainer, you're just offering a patch to
> add it to the build :)

Right...  I meant I am not going to become the maintainer of said 
patch/BK tree :)

	Jeff
