From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: 2+ raid sets, sata and a missing hd question
Date: Wed, 15 Feb 2006 18:44:29 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0602151842550.6126-100000@coffee.psychology.mcmaster.ca>
References: <20060215065028.GA2452@percy.comedia.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060215065028.GA2452@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> hint
> echo DEVICE partitions >> /etc/mdadm.conf
> mdadm -Esc partitions | grep ARRAY>> /etc/mdadm.conf
> 
> >All md partitions are of type fd (Linux raid autodetect).
> >
> this is surprisingly not at all relevant

I'm not sure about that.  I've accidentally shuffled disks before,
and 0xfd resulted in all the MD's coming to life again.  I never 
use /etc/mdadm.conf, since there doesn't seem to be much point...

regards, mark hahn.

