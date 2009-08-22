From: Info@quantum-sci.net
Subject: Re: Help
Date: Sat, 22 Aug 2009 05:56:32 -0700
Message-ID: <200908220556.32856.Info@quantum-sci.net>
References: <200908210627.06241.Info@quantum-sci.net> <200908212314.31887.Info@quantum-sci.net> <3d3031d0053a547684fa49ddc6532819.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3d3031d0053a547684fa49ddc6532819.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 22 August 2009 02:34:12 NeilBrown wrote:
> You say md0 is raid1 but mdstat shows it to be raid10, so that won't boot.

Thanks Neil.  However that was an early attempt before I knew RAID10 won't boot.


> 'raid autodetect' only works for 0.90 metadata, and you are using 1.x.
> You should not use 'raid autodetect' partitions.  Rather the initrd
> should use mdadm to assemble the arrays.  Most distros seem to get this
> right these days.  Maybe you just need to rebuild your
> initrd...

I am not using an initrd.  Have all the RAID and disk drivers built into the (custom-compiled) kernel.  It uses mdadm to assemble the arrays?  Maybe this is the problem.

I am using this procedure to build a RAID array from a live system:
http://www.howtoforge.com/software-raid1-grub-boot-debian-etch

It is very lucid and clear, however I am slightly modifying it to use RAID10 on my second and third partitions.  When I come to 
update-initramfs -u
... the only initrd it updates is for an old stock kernel.  It doesn't build one for any of my compiled kernels.

What partition type should I use rather than raid autodetect?  Or should I revert to 0.90 metadata?

Looking at dmesg it does say that md1 & 2 do not have a valid ==v.90== superblock.  There is no other linux raid partition type, so I guess it's got to be v.090.  Why do they make 1.1 and 1.2 then, if they do not work?

