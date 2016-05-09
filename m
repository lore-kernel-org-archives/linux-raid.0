From: SharksArt <sharksart@gmail.com>
Subject: Re: RAID5 - =?utf-8?b?cmVzaGFwZV9wb3NpdGlvbg==?= too early for auto-recovery - aborting
Date: Mon, 9 May 2016 16:43:48 +0000 (UTC)
Message-ID: <loom.20160509T184322-684@post.gmane.org>
References: <CAJwyido42Gk0uoMCKCLXk0dLfJ+J91uS=4N359fG0jkwg=jAGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I searched again on this mailing list and i've just found the
--update=revert-reshape and it works well ! My RAID 5 is now up and my
volume is Ok :)

In my case : mdadm --assemble --verbose --force --update=revert-reshape
--invalid-backup --backup-file=/whatever /dev/md/3 /dev/sd[bcdefg]6

Now, i will make a full backup of my datas before growing ^_^'

Laurent

