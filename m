From: Sandro Dentella <sandro.dentella@tin.it>
Subject: Re: mdadm: hot add failed ... lun0/part6: No space left on device
Date: Tue, 3 Feb 2004 09:01:04 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040203080104.GA10152@e-den.it>
References: <20040130123211.GA10754@e-den.it> <16411.34391.455191.631246@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16411.34391.455191.631246@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Sandro Dentella <sandro.dentella@tin.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 31, 2004 at 09:41:27PM +1100, Neil Brown wrote:
> >     # mdadm /dev/md1 --add /dev/ide/host0/bus1/target0/lun0/part6
> > 
> >   but I get:
> > 
> >   mdadm: hot add failed for /dev/ide/host0/bus1/target0/lun0/part6: No space left on device
> It means, as you guess lower down, that the partition you have
> provided appears to be too small to be used in the given array.
> 
> This error should cause a message to appear in the kernel logs
> something like
> 
>    md1: disk size XXX blocks < array size YYY
> 
> You might finding it by
>    dmesg | grep 'disk size'
> 
> or looking in some file in /var/log (depending on which distribution
> you use.  Debian puts it in /var/log/kern.log).

It's a pity the system was running on a rescue CD so when I had to reboot
(the client really needed to have it up soon) I lost the messages. I can
tell that I bypassed the problem swapping the position of the two HD (hda
and hdc). At that point both where seen in LBA mode and the partition could
be added... I that any usefull to help understand? Is there anything I
could/should have been done to avoid this behaviour?

Why hdc is so often seen not in LBA mode (BIOS set up correctly) until you
force it w/ fdisk while hda is always right?

Thanks for your help

sandro
*:-)

-- 
Sandro Dentella  *:-)
e-mail: sandro.dentella@tin.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
