From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: boot time autoassembly: how come it works?
Date: Wed, 4 Jun 2008 17:27:40 -0500
Message-ID: <20080604222740.GA32075@atlantis.cc.ndsu.NoDak.edu>
References: <4847119C.3070002@jellybean.co.uk>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4847119C.3070002@jellybean.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 04, 2008 at 11:05:16PM +0100, Jules Bean wrote:

> The docs (md.txt) say that auto-assembly only occurs if the RAID arrays are 
> marked as 'RAID autodetect' aka partition type 0xfd. On the other hand 
> mdadm needs mdadm.conf to get going.


You may to pull apart your initrd image and look at your init
script (or whatever your startup script is called) to see how it
is assembling your arrays.  If you're using user space to assemble
your arrays at boot time (i.e. mdadm via initrd) it is most likely
using the mdadm.conf file located in the initrd.  Typically,
mkinitrd is called when a new kernel is installed.  The mkinitrd
script will grab the necessary files (i.e. mdadm.conf) needed to
mount the root filesystem. 

I'm not sure I've seen a system auto assemble an array when the
partitions were not set to 0xfd.  My bet is that you have a
mdadm.conf file in your initrd and that the init script is
starting the array in user space via mdadm.

Though, I could be wrong :-)

Bryan 
