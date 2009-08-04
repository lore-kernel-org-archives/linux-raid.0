From: "NeilBrown" <neilb@suse.de>
Subject: Re: auto start raid0 with no superblock?
Date: Wed, 5 Aug 2009 08:35:03 +1000 (EST)
Message-ID: <e95ccd4bcc42879717ea2ee8d02aaeba.squirrel@neil.brown.name>
References: <200908041444.52747.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908041444.52747.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, August 5, 2009 6:44 am, Thomas Fjellstrom wrote:
> I'm testing out accessing a "Windows DynamicDisk Raid0" array under linux,
> and
> for the most part it works very well. My only problem is mdadm will not
> auto
> start the array even when I have it setup in mdadm.conf (mdadm is told to
> auto
> start all arrays found there). Basically I have to manually run "mdadm
> --build
> /dev/md0 --chunk=64 --level=raid0 --raid-devices=4 /dev/sdc1 /dev/sdd1
> /dev/sde1 /dev/sdf1" then "mount /mnt/winraid" when I want to access the
> filesystem (using ntfs-3g if anyone was wondering).

Of course you don't have to run it manually.  You can put it in
a script in /etc/rc5.d/Sxxwhatever

That is in fact the recommended way of doing this.  There is really
nothing that mdadm can do for you to make this any easier, so it
doesn't bother.

>
> All I get from mdadm/syslog is this:
> Aug  4 02:43:10 natasha kernel: [    7.862373] md: md0 stopped.
> Aug  4 02:43:18 natasha mdadm[3597]: DeviceDisappeared event detected on
> md
> device /dev/md0
>
> The reason I'm trying to use non persistent superblocks is I'm assuming
> trying
> to save them will damage the windows DynamicDisk metadata in some way.

Sounds very sensible.

NeilBrown

