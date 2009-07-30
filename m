From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: PCI device initialisation and RAID assembly
Date: Thu, 30 Jul 2009 09:14:33 +0100
Message-ID: <4A715669.3010104@anonymous.org.uk>
References: <4A70D0C3.9000901@elsabio.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A70D0C3.9000901@elsabio.demon.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: m.hewitt@computer.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/07/2009 23:44, Mark J Hewitt wrote:
> I think I have an issue here with initialization timing of a PCI SATA 
> card and a RAID 5 array assembly.
[...]
> Jul 29 19:56:53 janus kernel: raid5: raid level 5 set md0 active with 2 
> out of 3 devices, algorithm 2
> ... later!
> Jul 29 19:56:53 janus kernel: sata_sil 0000:05:09.0: PCI INT A -> GSI 18 
[...]
> Is there anything I can do about this?

Try adding sata_sil into your initrd? You can do this manually with 
extra options to the mkinitrd command, or automatically by adding it 
into your /etc/modprobe.conf; mine has these lines in it:

alias scsi_hostadapter pata_marvell
alias scsi_hostadapter1 ahci

You'll still need to run mkinitrd after editing /etc/modprobe.conf this 
time, but at least when you update your kernel and a new initrd is made 
for it, it will automatically include sata_sil.

Cheers,

John.

