From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Problems with multiple Promise SATA150 TX4 cards
Date: Wed, 25 Jan 2006 00:27:43 +1100
Message-ID: <43D62B4F.1080505@nighthawkrad.net>
References: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca> <43D5EF58.9010807@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D5EF58.9010807@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote:
> 
> I have 3 cards with 12 drives in one box, and 4 card with 15 drives in 
> another.
> They work just dandy. They are not the fastest machines in the world, 
> and the PCI but sometime groans under the strain, but it's reliable and 
> error-free.

Are these the same cards I have ?

> Can you send an lspci -vv please? I did have some strange problems with 
> the BIOS setting up weird timing modes on some of the cards. This did 
> not present a reliability problem for me, just performance however.

I attached lspci output to my original post.  I have also included it on 
the end of this one (with a slight difference regarding which slots the 
cards were in, but that makes no difference to the problem).

> My 1st quick and dirty test would be to boot with a UP kernel. (Only 
> because that is all I have also) And to try a vanilla kernel.org kernel 
> rather than the Redhat one. (I have one machine on 2.6.10 and one on 
> 2.6.15-git11. Both are solid)

I have tried the latest Fedora Core 4 kernel, both SMP and UP.  I have 
also tried their 2.6.11 UP kernel (2.6.11-1.1369_FC4).

All exhibit the problem, although it appears that the 2.6.11 kernel 
takes slightly longer for it to appear (maybe 10 vs 5 seconds).

I have not tested with a vanilla kernel.  I'll try to do it tomorrow 
(although I suspect it won't help).

> bklaptop:~>ssh storage1 uname -a
> Linux storage1 2.6.15-git11 #1 Sun Jan 15 22:25:19 GST 2006 i686 GNU/Linux
> bklaptop:~>ssh srv uname -a
> Linux srv 2.6.10 #4 Mon Feb 14 23:10:38 GST 2005 i686 GNU/Linux
> 
> Are you using the cards in standard PCI 33Mhz Slots? I recall an issue a 
> while ago where someone had a big problem with the cards in 66Mhz Slots.

The cards were all in PCI-X slots ranging from 64/66 to 64/133.

I tried placing one of the cards in the only regular 32/33 PCI slot my 
motherboard has and it does not help (this is the configuration where 
the attached lspci was taken).

> Another test I'd like you to try if you would, is place one or two 
> drives on each controller, so you only have 3 in the system.. and then 
> try to reproduce the error.

This configuration also produces the error.

Something else I tried was some crappy dual-port SIL-based SATA card 
with two of the Promise TX4s, and that worked without a problem.  While 
I'm waiting to find out what this is, I might buy another one and use 
the two of them temporarily so I can build my RAID array, at least.

Thanks for your help.

CS
