From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: Clarify /etc/mdadm.conf format and content?
Date: Thu, 5 Nov 2009 08:24:29 -0800
Message-ID: <babafd2f0911050824u327c2ca3y43ab557b52f9356@mail.gmail.com>
References: <babafd2f0911042153y427d3194w520f2294f0ff7f53@mail.gmail.com>
	<4877c76c0911042217r76d7e46cg4ceeb391e9098a6@mail.gmail.com>
	<babafd2f0911042321k4dfda707he80f40596fba2a3b@mail.gmail.com>
	<4877c76c0911042331i15f53768s382512200f02c398@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911042331i15f53768s382512200f02c398@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 4, 2009 at 11:31 PM, Michael Evans <mjevans1983@gmail.com> wrote:
> To better cooperate with various initrd and recovery cd you should
> probably use a numeric only array name, as well as the /dev/mdX
> numbering scheme.

Ok.  That still doesn't address why different commands in mdadm
generate different numbering schemes.

> You should read the manuals more carefully, it is possible to update
> the name and/or homehost name for arrays DURING ASSEMBLY using the
> update option, hence my reference to the manual.

I read the man pages.  I don't understand what's written there.  I'm
asking questions about it here.

How do I change the name= spec'n?  Do I simply add something to
/etc/mdadm.conf and reboot?  Or do I need to init3, stop the LVM, stop
the array, assemble-with-update, change in mdadm.conf, then ,
re-mkinitrd?  Or, since mdadm.conf is ON root ON the arary do I need
to boot from a rescue disk, then complete all the steps?

Can you please be less cryptic and share what you seem to know, rather
than telling me to RTFM?  If you can't or won't, that's fine.  Just
say so, and I'll wait for other help.

Thanks.

BenDJ
