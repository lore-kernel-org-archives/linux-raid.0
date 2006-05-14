From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: softraid and multiple distros
Date: Sun, 14 May 2006 10:50:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0605141048330.7486-100000@coffee.psychology.mcmaster.ca>
References: <200605141547.46271.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200605141547.46271.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> What do I need to do when I want to install a different distro on the machine 
> with a raid5 array?
> Which files do I need? /etc/mdadm.conf? /etc/raittab? both?

MD doesn't need any files to function, since it can auto-assemble
arrays based on their superblocks (for partition-type 0xfd).

