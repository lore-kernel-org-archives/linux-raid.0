From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: transferring RAID-1 drives via sneakernet
Date: Wed, 13 Feb 2008 12:25:14 +0300
Message-ID: <47B2B77A.5070702@msgid.tls.msk.ru>
References: <e03b90ae0802111659v2889dc52kc6eed9dfc9478f9e@mail.gmail.com>	 <47B1633F.5030403@dgreaves.com>	 <e03b90ae0802121050t192fba6ai5c10338844a60a05@mail.gmail.com>	 <47B1ECD2.8070406@redhat.com> <e03b90ae0802121914q595a492ft844bde202bd09a0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e03b90ae0802121914q595a492ft844bde202bd09a0d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Breidenbach wrote:
>> It's not a RAID issue, but make sure you don't have any duplicate volume
>> names.  According to Murphy's Law, if there are two / volumes, the wrong
>> one will be chosen upon your next reboot.
> 
> Thanks for the tip. Since I'm not using volumes or LVM at all, I should be
> safe from this particular problem.

If you don't use names, you use numbers - like md0, md10 etc.
The numbers, as they now ARE names, should be different too.

There's more to this topic, much more.

There are different ways to start (assemble) the arrays.  I know at
least 4 - kernel autodetection, mdadm with mdadm.conf listed some
devices, mdadm with "empty" mdadm.conf and with using of 'homehost'
parameter (assemble all "our" arrays), and mdrun utility.  Also,
some arrays may be assembled during initrd/initramfs stage, and some
after...

The best is either mdadm with something in mdadm.conf, or mdadm with
homehost.  Note that neither of these ways, your "foreign" array(s)
will be assembled, and you will have to do it manually - wich is much
better than to screw things up trying to mix-n-match pieces of the
two systems.  You'll just have to figure the device numbers of your
"foreign" disks and issue an appropriate command, like this:

  mdadm --assemble /dev/md10 /dev/sdc1 /dev/sdd1 ...

using not yet taken mdN number and the right device nodes for your
disks/partitions.

If you want to keep the disks here, you can add the array info into
mdadm.conf or refresh superblock to have new homehost.

But if you're using kernel autodetection or mdrun... well, I for
one can't help here, -- your arrays will be numbered/renumbered
by a chance...

/mjt
