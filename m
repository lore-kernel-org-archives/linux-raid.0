From: David Nedved <dnedved@nuvox.net>
Subject: how do I change md1 to md2?
Date: Mon, 10 Jun 2002 10:09:00 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020610100900.T2266@nuvox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

Thanks for everyone who helped me get my md1 data volume brought up
correctly.  Now I have another issue.  I've rebuilt my host OS using
RedHat 7.3, and I loaded it on RAID1 also.  I built my data volume as
md1 so that I could load the OS on md0, but I forgot about swap.

Now I have md0 as /, md1 as swap, and another md1 data volume that
won't activate since there is already an md1 in use as swap.

Can anyone help me get my data volume brought up as md2?  I have it in
the raidtab as md2, but during boot it reads the superblock and knows it's
md1, but won't bring it up since there's already an md1.  I've gone back
to the old OS disk, so I don't have logs handy, but if they're critical it
won't be a problem to post them.  I looked byt coulnd't find any pointer
in the FAQ or Howto's...

I know I could probably turn swap off, so that the data volume activates
correctly, but I'm considering putting software RAID1 onto production
servers, and now that I've found this issue, I really feel I need to
understand how to manage it rather than work around it.

Thanks in advance,

David
