From: Neil Brown <neilb@suse.de>
Subject: Re: programmatic API?
Date: Thu, 25 Feb 2010 21:46:12 +1100
Message-ID: <20100225214612.1e5f8de5@notabene.brown>
References: <27127259.41267088084737.JavaMail.root@wombat>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27127259.41267088084737.JavaMail.root@wombat>
Sender: linux-raid-owner@vger.kernel.org
To: bardov@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 Feb 2010 03:54:44 -0500
bardov@gmail.com wrote:

> I'd like to create/manage raid arrays from a program.
> Is there an API, or a library I can link with? 
> Or is my only option using system("mdadm ..."); ?
> 
>

You can do almost anything by reading/writing files
in /sys/class/block/mdX/md/
Some details are in Documentation/md.txt
For the few things that you cannot do through sysfs, you would use an IOCTL.

But I suspect that fork/exec("/sbin/mdadm" ....)
would be your best bet, though it depends on exactly what you want to do.

There is no library, but there a plenty if bits of code in the mdadm source
that you might want to borrow if your program will be GPL.

NeilBrown
