From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID design
Date: Sat, 12 Jul 2003 18:56:57 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0307121851290.6220-100000@unicorn.drogon.net>
References: <20030712173430.GA8599@bluff.diade.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030712173430.GA8599@bluff.diade.it>
To: Sandro Dentella <sandro.dentella@tin.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 12 Jul 2003, Sandro Dentella wrote:

>   You also need to install GRUB (od lilo) on both disks, as I
>   understand. Reallu I never understood how to do that from living hard
>   disk, so I normally need to install GRUN from floppy the first time it
>   starts.

I've not used GRUB.. Stuck with Lilo..

With a new Lilo, (2.22)

  http://www.tldp.org/HOWTO/Software-RAID-HOWTO-4.html#ss4.11

and the magic lilo runes you need are:

  boot=/dev/md0
  root=/dev/md0
  raid-extra-boot=/dev/hda,/dev/hdc

along with everything else.


Gordon

