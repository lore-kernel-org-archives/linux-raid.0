From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Ext3 inconsistencies
Date: Tue, 19 Aug 2003 17:58:38 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0308191756210.7175@unicorn.drogon.net>
References: <12932735343.20030819181720@xhost.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12932735343.20030819181720@xhost.cz>
To: Vladimir Trebicky <trebicky@xhost.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 19 Aug 2003, Vladimir Trebicky wrote:

> Hi,
>
>    recently, I did a e2fsck -nf /dev/md0 (running ext3 rootfs 1GB).
>    I have some    disturbing messages that I wish to discuss and ask
>    whether it has something to do with my RAID1:
>
> many many many many lines like this one:
> Illegal block #13 (1951605306) in inode 31988.  IGNORED.

Probably a daft question, but did you run the fsck with it mounted and the
system live, or booted off a rescue CD/Floppy?

It will fail if the filesystem is mounted (but ought to tell you)

Gordon
