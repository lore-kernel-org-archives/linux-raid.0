From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Software RAID and Fakeraid
Date: Mon, 31 Jan 2011 11:44:07 -0500
Message-ID: <4D46E6D7.2000205@cfl.rr.com>
References: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>	<4CF55680.5010703@cfl.rr.com>	<20101201092508.7023f974@notabene.brown>	<4CF81A16.2010606@cfl.rr.com>	<20101203123615.6edce071@notabene.brown>	<4CF860EB.7010005@cfl.rr.com>	<20101209094354.4c6aaa93@notabene.brown> <4D01328D.9050503@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D01328D.9050503@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, John Sheu <john.sheu@gmail.com>
List-Id: linux-raid.ids

I know you went on vacation over the new year, but it has been about two
months now so I figured I would try to revive this conversation.

Having collected my thoughts, this is what I propose:

I believe that right now, grub recognizes an md device that is built on
partitions, and installs to the underlying disks.  When the device is
built on the whole disks, it needs to divide into two categories:

1)  Native md metadata.  Grub should ask mdadm for a suitable location
to embed the core image on each component disk.  This can be satisfied
with a 32kb area at the end ( or maybe the beginning ) of the disk that
is not used by the array ( or the metadata ).  This will work for all
native formats except for 1.1, for the obvious reason that it is using
the boot block.

2)  Other metadata formats.  Either assume or explicitly be told by
mdadm that these formats are fakeraid and thus understood by the bios
int 13.  Grub installs to the array as a whole, just like it does today
when they are handled by dmraid.  If it is known that it is not bios
supported, then error out.  In the future this could be supported by
creating additional grub modules that understand those metadata formats.

One question that needs answered for method 1 is what should the
partition table look like?  Should grub, or maybe mdadm, create a
protective mbr when using the whole disk, similar to the one used with GPT?
