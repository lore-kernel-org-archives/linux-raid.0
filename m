From: ross@lug.udel.edu
Subject: RAID-1 reconstruction
Date: Thu, 21 Apr 2005 14:25:50 -0400
Message-ID: <20050421182550.GA7926@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

I've got three RAID-1 setups in my workstation, they work like champs
and I'm amazed at the quality.  Thanks!

I just had a realtime application deadlock the system.  The only thing
I could do was Magic SysRQ out of it.  Hit SysRq-s, SysRq-u, SysRq-b.

When the system rebooted, my RAID all came back as in sync.  This
surprised me!  The md assembly seems to have gone well.

Is this a new feature?  I fully expected to have to rebuild my arrays.

Thanks - if it's correct, I must say I'm surprised!

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
