From: Petr Vyskocil <petr@anime.cz>
Subject: Re: I need a PCI V2.1 4 port SATA card
Date: Wed, 28 Jun 2006 14:12:06 +0200
Message-ID: <e7trmu$6ii$1@sea.gmane.org>
References: <200606280245.k5S2jkB24340@www.watkins-home.com> <44A205BC.90808@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44A205BC.90808@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote:
 > I'd love to do something similar with PCI-E or PCI-X and make it go
 > faster (the PCI bus bandwidth is the killer), however I've not seen
 > many affordable PCI-E multi-port cards that are supported yet and
 > PCI-X seems to mean moving to "server" class mainboards and the other
 > expenses that come along with that.

Recently I was looking for a budget solution to exactly this problem, 
and the best I found was to use 2-port SiI 3132 based PCI-E 1x card 
combined with 1:5 SATA Splitter based on SiI 3726 (e.g. 
http://fwdepot.com/thestore/product_info.php/products_id/1245). 
Unfortunately I didn't find anyone selling the splitter here in Czechia, 
so I went with 4-port SiI PCI card, which is performing well and stable, 
but of course quite slow.

Some test I googled up at that time suggested that this combo can get 
about 220MB/s bandwidth through in real life (test was on Win32 though), 
so at today's drive speeds you can connect ~4-5 drives to one PCI-E 
without bus bandwidth becoming the limiting factor.

Anyway, for really budget machines I can recommend the PCI SiI 3124 
based cards, the driver in kernel is working rock-stable for me. Only 
grudge is that driver doesn't sense if you disconnect a drive from SATA 
connector, i.e. when you do that, computer will freeze trying to write 
to disconnected drive. After ~3 minutes it times out and md kicks the 
drive out of the array, though.

If someone has any experience to share about SiI 3132+3726 under linux, 
I'll be happy to hear about it. According to 
http://linux-ata.org/software-status.html#pmp it should work, question 
is how stable it is, since it is recent development.

Petr

