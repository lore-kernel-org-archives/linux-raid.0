From: Neil Brown <neilb@suse.de>
Subject: Re: Clarify /etc/mdadm.conf format and content?
Date: Mon, 9 Nov 2009 15:57:22 +1100
Message-ID: <19191.41266.193710.349961@notabene.brown>
References: <babafd2f0911042153y427d3194w520f2294f0ff7f53@mail.gmail.com>
	<4877c76c0911042217r76d7e46cg4ceeb391e9098a6@mail.gmail.com>
	<babafd2f0911042321k4dfda707he80f40596fba2a3b@mail.gmail.com>
	<4877c76c0911042331i15f53768s382512200f02c398@mail.gmail.com>
	<babafd2f0911050824u327c2ca3y43ab557b52f9356@mail.gmail.com>
	<babafd2f0911050903y5a12f2c4r2a94dc9832ef944b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ben DJ on Thursday November 5
Sender: linux-raid-owner@vger.kernel.org
To: Ben DJ <bendj095124367913213465@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 5, bendj095124367913213465@gmail.com wrote:
> Neil,
> 
> Reading your blog post,
> 
>   "Auto-assembly mode for mdadm"
>    http://neil.brown.name/blog/20060521092609
> 
> Section "Bootstrapping" says
> 
> -------------
> On problem with introducing this functionality is that people have
> pre-existing array that aren't tagged with the host name. To help we
> this we will have a new 'update' option of --assemble:
> --update=homehost which will update the host information in the
> superblock prior to assembly. This is usable fairly easily for
> everything except an array holding a root filesystem. In order to
> avoid needing to boot from different media, there will be an option
> that can safely be used from an initramfs which will do the right
> thing.
> 
> This will probably be called --auto-update-home-host.
> 
> This option is only meaningful when doing a hostname based auto
> assembly. If the autoassembly process finds anything to assemble, the
> option is ignored. However if nothing is found with the right host
> name, then a second pass is made. On this pass, any md array that is
> found is updated to belong to the current host, and is automatically
> assembled.
> 
> Thus it should be safe to always run mdadm with
> --auto-update-home-host in initramfs. It will only do its magic once,
> and after that the arrays should always assemble properly.
> -------------
> 
> That describes the situation I have -- an array holding the root file
> system, that's not tagged with the hostname.
> 
> Can you please explain HOW one runs "with --auto-update-home-host in
> initramfs" "to avoid needing to boot from different media"?  My
> existing arrays are tagged with the wrong name, and I'm simply trying
> to correct it.

You would need to modify the initramfs ... or get it to give you a
shell prompt so you can run the commands by hand.
The details of doing this depend very much on the distro and the
content of the initramfs it creates.

If you want to change the name in an array that hold your root
filesystem, your best approach would be to boot from a CDROM and 
then use e.g.
   mdadm --assemble /dev/md --update=name --name=foo:bar  /dev/list-of-devices

NeilBrown
