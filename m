From: Luca Berra <bluca@comedia.it>
Subject: Re: Bug report: mdadm -E oddity
Date: Sun, 15 May 2005 19:32:01 +0200
Message-ID: <20050515173200.GA20966@percy.comedia.it>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com> <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com> <17029.12773.197506.463977@cse.unsw.edu.au> <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i would like to add some comments
On Sat, May 14, 2005 at 09:28:35AM -0400, Doug Ledford wrote:
>Actually, what I'm working on is Fedora Core 4 and the boot up sequence.
>Specifically, I'm trying to get the use of mdadm -As acceptable as the
hint, mdassemble :)

>So, here's some of the feedback I've gotten about this and the
>constraints I'm working under as a result:
initrd should be used to mount root filesystem, handling other stuff in
initrd is just asking for more trouble

>     1. People don't want to remake initrd images and update mdadm.conf
>        files with every raid change.  So, the scan facility needs to
>        properly handled unknown arrays (it doesn't currently).
do really people change the UUID of the array containing / that often?

>     2. People don't want to have a degraded array not get started (this
>        isn't a problem as far as I can tell).
what would be the issue causing this.

>     3. Udev throws some kinks in things because the raid startup is
        i run udevstart in initrd after loading modules and before
        assembling md's. if nash was a better shell, i could use udev
        instead of udevstart

>        have completed).  However, with the advent of stacked md
        mdadm should create device files for md arrays if you ask it to,
        is this what you are after or are there other issues

>     4. Currently, the default number of partitions on a partitionable
        ....
>        numbers relative to how the array was created.  I would suggest
>        encoding this somewhere in the superblock and then setting this
>        to 0 on normal arrays and non-0 for partitionable arrays and
>        that becomes your flag that determines whether an array is
>        partitionable.
        agreed

>     5. I would like to be able to support dynamic multipath in the
>        initrd image.  In order to do this properly, I need the ability

i don't like using fc for boot disks, so i never tried, and i'll just
shut up.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
