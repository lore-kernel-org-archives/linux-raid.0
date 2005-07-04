From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Why does my drive get set readonly?
Date: Mon, 4 Jul 2005 17:02:19 +1000
Message-ID: <17096.57083.572126.181450@cse.unsw.edu.au>
References: <Pine.LNX.4.61.0506291431530.7208@filestore.ivimey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ruth Ivimey-Cook on Wednesday June 29
Sender: linux-raid-owner@vger.kernel.org
To: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 29, Ruth.Ivimey-Cook@ivimey.org wrote:
> 
> Hi,
> 
> I'm hoping someone can help suggest where I might look to sort a problem. even 
> a pointer is useful!
> 
> I have three raid arrays, two raid1 and one raid5 called md2. Basically they 
> run fine, but something is switching md2 readonly during the boot process; the 
> only way I can get the machine to reboot is to remove md2 from fstab, boot 
> single-user, do an "mdadm -w /dev/md2", then "init 5".
> 
> I'm running Fedora 3 in a very standard configuration.
> 
> Here's the dmesg output (with the new printk timestamp option enabled). Note 
> the line just after the block of selinux calls.
> 
> What could be setting it readonly?

Odd !!

> [4294696.943000] md: md2 switched to read-only mode.

In the mainline kernel, only two thing can cause this to happen.
1/ if an array is still active during shutdown, it will be switched to
   read-only.
2/ if some user-space program call the ioctl equivalent to "mdadm --readonly".

However it is possible that the Fedora-3 kernel does extra stuff
... maybe related to selinux ???

I would suggest asking in a Fedora-specific forum.

(feel froo to quote anything I have said there).

NeilBrown
