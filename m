From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: softraid and multiple distros
Date: Mon, 15 May 2006 08:16:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0605150812350.9516-100000@coffee.psychology.mcmaster.ca>
References: <200605151350.06175.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200605151350.06175.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > or zero the superblock or both...
> 
> More questions: is the raid superblock the same as an "ordinary" file system 
> superblock? 

iirc, the raid SB is at the end, and most FS's base theirs at the beginning.

> "Zero" the superblock - the orphaned one, I assume? This is not like "zero it 
> and linux makes a new one" or so?

zero it so that you're not presenting inconsistent stuff to mdadm
when it tries to auto-assemble.

