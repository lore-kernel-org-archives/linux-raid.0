From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Linux raid wiki - setting up a system - advice wanted :-)
Date: Mon, 26 Sep 2016 07:50:56 +0100
Message-ID: <57E8C550.8000509@youngman.org.uk>
References: <57E83EA8.9060809@youngman.org.uk>
 <20160926021622.GA25056@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160926021622.GA25056@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/09/16 03:16, Andreas Klauer wrote:
> On Sun, Sep 25, 2016 at 10:16:24PM +0100, Wols Lists wrote:
>> > I need to know what will happen if you give entire drives to mdadm.
> Installers will pick unpartitioned disks first. Forget just trashing 
> the metadata, easy to accidentally write across the entire disk.
> 
> This is what it looks like when installing Windows: http://imgur.com/a/GtcR2 
> 
> Same can happen with Linux installers. Unpartitioned disks are just unusual. 
> 
> Not sure why this is a thing anyway. There's no downside to partitions. 
> Adds a safety margin, is yet another place that has metadata (with GPT 
> you can use mdnumber-role as partition name / partlabel), doesn't harm 
> performance in any way...

Actually, there IS a downside, which is what I'm getting at.

Bare metal -> partitions -> raid -> lvm -> partions ...

I'm a DB guy by trade. I hate relational DBs with a vengeance - because
they are necessarily complex thanks to relational theory but because
they are also so totally UNnecessary if people weren't wedded to the
(totally impractical in the real world) maths!

I know what I'm doing here. I'm very bright. And I'm trying to work out
how to explain myself without leaving your "bear of very little brain"
in charge of sys-adminning a server scratching his head in confusion
trying to work out what goes where.

As far as linux is concerned, a block device is a block device. But the
poor sysadmin has got to get his head round what goes where, and my
experience with DBs tells me that most people probably aren't as bright
as us ...

At the end of the day, I don't want to recommend anything. I simply want
to know - is it *possible*. Unfortunately, I don't have the hardware to
try it myself :-( The setup I want to know is

Bare metal -> raid [-> lvm] -> /

Is there any room on the disk to install grub?

(Note that - and I know you shouldn't believe everything you read on the
internet - apparently Neil Brown prefers passing the entire
unpartitioned disk to raid ...)

Cheers,
Wol
