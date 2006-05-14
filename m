From: Neil Brown <neilb@suse.de>
Subject: Re: softraid and multiple distros
Date: Mon, 15 May 2006 08:47:28 +1000
Message-ID: <17511.45952.33107.517125@cse.unsw.edu.au>
References: <200605141547.46271.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Sunday May 14
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 14, Dexter.Filmore@gmx.de wrote:
> What do I need to do when I want to install a different distro on the machine 
> with a raid5 array?
> Which files do I need? /etc/mdadm.conf? /etc/raittab? both?

That depends a lot on the distros.

Some really old distro might be using /etc/raidtab, and some new
distros don't support it at all.
Some distros try to assemble all md arrays in the initrd, and some
mess this up in various ways.

If your root filesystem isn't on md/raid then it should be enough to
just preserve /etc/mdadm.conf, though it is fairly easy to recreate
that.  "mdadm -Escparititions" gives you a good starting point - edit
it to make it just right.

If your root is on md/raid, then you'll probably need to look into how
the initrd works (assuming the distros install program does just get
it right).

NeilBrown
