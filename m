From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] klibc update
Date: Tue, 16 Mar 2004 11:10:26 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040316111026.6729e153.akpm@osdl.org>
References: <4056B0DB.9020008@pobox.com>
	<20040316005229.53e08c0c.akpm@osdl.org>
	<20040316153719.GA13723@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040316153719.GA13723@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, viro@parcelfarce.linux.theplanet.co.uk, bos@serpentine.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg KH <greg@kroah.com> wrote:
>
> On Tue, Mar 16, 2004 at 12:52:29AM -0800, Andrew Morton wrote:
> > 
> > It's so long since klibc was discussed (ie: more than five minutes ago)
> > that I forget the reasons why it should be delivered via the kernel tree.
> > 
> > Remind me please?
> 
> We need a way to build the userspace programs that get put into
> initramfs that will be needed to boot the kernel.
> 
> That help?

My grey cells thank you.

Does klibc have a bk home anywhere, so I can start sucking it in?
