From: Martin Wilck <mwilck@arcor.de>
Subject: Re: mdadm >= 3.0 - udev test rule
Date: Tue, 08 Oct 2013 20:40:36 +0200
Message-ID: <525451A4.9070504@arcor.de>
References: <CAHsdBYNPTp1tB9RsLPHAsCaFbSxMA2OZ3cqbqyKsqrjcC7-jkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHsdBYNPTp1tB9RsLPHAsCaFbSxMA2OZ3cqbqyKsqrjcC7-jkA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hristo Chonov <chonov@vkm.tu-darmstadt.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/08/2013 02:12 PM, Hristo Chonov wrote:
> Hello,
> 
> I have just a simple question about the udev rule:
> TEST!="md/array_state", GOTO="md_end" or in the last two releases with
> the systemd support: TEST!="md/array_state", ENV{SYSTEMD_READY}="0",
> GOTO="md_end".
> 
> We are running a XenSever 6.2 system which is based on CentOS 5.7 with
> included an old version of udev: udev-095. This version doesn't
> support the ATTR keyword so I am going to swap it with the old one
> SYSFS, but it appears that udev doesn't recognize as well the TEST
> keyword, so I am wondering what exactly this rule is there for? Is it
> checking if "md/array_state" appears somewhere in the attributes and
> if not it jumps to "md_end"?

from mdadm(8):
TEST{octal mode mask}
           Test the existence of a file. An octal mode mask can be
specified if needed.

So, this checks if the file "/sys/class/block/md$X/md/array_state"
exists, and exits otherwise.

> And do you have any idea how the rule should be rewritten for older
> versions of udev?

It could probably be done with PROGRAM="/bin/test -f md/array_state" or
the like (not tested).

Martin
