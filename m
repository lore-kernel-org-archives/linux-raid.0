From: "NeilBrown" <neilb@suse.de>
Subject: Re: No md superblock immediately after creating RAID 5 /dev/md0
Date: Fri, 29 Aug 2008 16:01:23 +1000 (EST)
Message-ID: <d44a774691620d6964cda2b543a61be9.squirrel@neil.brown.name>
References: <8CAD6FFC01AB7AC-524-231A@webmail-nf07.sim.aol.com>
    <9b4ac8ccbe69d232ff2d77fd4e3590c2.squirrel@neil.brown.name>
    <8CAD7B1E82C6F54-1068-40D8@MBLK-M01.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CAD7B1E82C6F54-1068-40D8@MBLK-M01.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, August 29, 2008 3:47 pm, thomas62186218@aol.com wrote:
>
> Hi Neil,
>
> Sorry for the confusion. I mistyped the -C command in my initial email
> (forgot the hot-spare) and thus the confusion.
>
> Here is the full output from the top using copy/paste. Thank you in
> advance for your help!!

In the first mail you sent, there was an mdadm.conf.
But now:


> root@localhost:~# cat /etc/mdadm.conf
> root@localhost:~#

there isn't.
Why is that?

If you want mdadm to assemble an array you need to tell it where to find
the devices and how to recognise them.  The mdadm.conf you had before
was exactly the right sort of thing to have.
Without it you need to be more explicit
  mdadm -A /dev/md0 /dev/sd[b-m]
maybe.
Or after creating the array
  mdadm -D > /etc/mdadm.conf

NeilBrown

