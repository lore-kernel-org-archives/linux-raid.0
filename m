From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: new raid system for home use
Date: Mon, 19 Apr 2004 13:50:21 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404191348190.12466-100000@coffee.psychology.mcmaster.ca>
References: <4083FC32.7050103@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4083FC32.7050103@pobox.com>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >> I was under the impression that I can't boot off raid-5, but if that
...
> If you can load an initrd, you can boot off of anything.

indeed, you may not even need initrd - I usually have a boot kernel with 
monolithic (non-modular) boot device support.  the result is that as long 
as lilo/grub can reads a MB or so off some device, you can boot.

regards, mark hahn.

