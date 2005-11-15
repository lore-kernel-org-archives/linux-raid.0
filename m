From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: Re: Autostart RAID1 on boot
Date: Tue, 15 Nov 2005 12:06:03 -0500
Message-ID: <20051115170603.GA32673@jose.lug.udel.edu>
References: <437A11F3.90204@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <437A11F3.90204@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Spencer Tuttle <rodeojones@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 15, 2005 at 09:50:59AM -0700, Spencer Tuttle wrote:
> What do I have to do to autostart this array on boot?

Read Documentation/md.txt in your kernel source.  Has lots of cool
options for setting up kernel assembly on boot.

If you have a reasonably recent array with persistent superblocks,
something like this will do you fine for your root partition:
	md=0,/dev/hda1,/dev/hdc1

If you use initrd/early userspace stuff then you can also drop mdadm
in your initrd image and get it to start the array.  If you're using
Debian, it's mkinitrd scripts automatically support that if you get
things setup properly.

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
