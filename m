From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: disks becoming slow but not explicitly failing anyone?
Date: Sat, 22 Apr 2006 20:45:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0604222039500.6786-100000@coffee.psychology.mcmaster.ca>
References: <17482.35982.996526.551753@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17482.35982.996526.551753@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> This has happened with 7 (seven!!) disks already, 80GB and 120GB,
> Maxtor and Seagate. Has anyone else seen this?

sure.  but you should be asking what's wrong with your environment
or supply chain to cause this kind of disk degradation.  how's your 
cooling?  power?  some people claim that if you put a normal (desktop)
drive into a 24x7 server (with real round-the-clock load), you should 
expect failures quite promptly.  I'm inclined to believe that with 
MTBF's upwards of 1M hour, vendors would not claim a 3-5yr warranty
unless the actual failure rate was low, even if only running 8/24.

