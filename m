From: tc lewis <tcl@bunzy.net>
Subject: Re: how do I change md1 to md2?
Date: Mon, 10 Jun 2002 12:27:49 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0206101136020.19487-100000@magician.bunzy.net>
References: <20020610100900.T2266@nuvox.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020610100900.T2266@nuvox.net>
To: David Nedved <dnedved@nuvox.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


i believe you can use neil brown's mdadm utility to update superblock
data:
http://www.cse.unsw.edu.au/~neilb/source/mdadm/

according to a recent mail in the archive, version 1.0.0 is recommended
and 1.0.1 is experimental.  i've never used the utility myself.

i think there was also an old trick to adjust your raidtab, but change one
of your "raid-disk"s to a "failed-disk", in the config for the proper md
device entry, and run mkraid --force /dev/md?, and that would write a new
superblock yet not erase all the data (as long as it thought there was a
failed disk)...but you should probably get confirmation / more details on
that first if you're going to try that method, to prevent losing data.

you may also be able to add arguments to your kernel loader, re: with lilo
or whatever.  Documentation/md.txt in the linux source has info on that.
that may work to override a device # for that boot, but it won't fix the
superblock permanently.

i'm sure there are other methods too.  i'm not sure what the most
recommended option is these days -- mdadm, perhaps.

search a linux-raid archive for more info on mdadm, or its previous name,
mdctl.

-tcl.


On Mon, 10 Jun 2002, David Nedved wrote:

> Hi All,
>
> Thanks for everyone who helped me get my md1 data volume brought up
> correctly.  Now I have another issue.  I've rebuilt my host OS using
> RedHat 7.3, and I loaded it on RAID1 also.  I built my data volume as
> md1 so that I could load the OS on md0, but I forgot about swap.
>
> Now I have md0 as /, md1 as swap, and another md1 data volume that
> won't activate since there is already an md1 in use as swap.
>
> Can anyone help me get my data volume brought up as md2?  I have it in
> the raidtab as md2, but during boot it reads the superblock and knows it's
> md1, but won't bring it up since there's already an md1.  I've gone back
> to the old OS disk, so I don't have logs handy, but if they're critical it
> won't be a problem to post them.  I looked byt coulnd't find any pointer
> in the FAQ or Howto's...
>
> I know I could probably turn swap off, so that the data volume activates
> correctly, but I'm considering putting software RAID1 onto production
> servers, and now that I've found this issue, I really feel I need to
> understand how to manage it rather than work around it.
>
> Thanks in advance,
>
> David
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



