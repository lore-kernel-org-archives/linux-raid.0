From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID 1 and grub
Date: Thu, 31 Jan 2008 14:37:40 +1300
Message-ID: <47A12664.8030601@sauce.co.nz>
References: <47A0F4DC.9030005@sauce.co.nz> <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Rees wrote:

> Have you tried re-running grub-install after booting from a rescue disk?
> 
> -Dave

Hi David,

I have but although I can advance further it seems that the BIOS is 
doing some strange things as well, switching drive ordering around.

With a new hda installed and partitioned, ready to be rebuilt, the good 
drive, hdc installed, the grub.conf modified to address (hd2,0) - I have 
  an hdb installed also, and grub installed on hdc, booting with the 
BIOS set to start on hdc hangs with the message "grub stage2" then drops 
to a grub prompt.

I then enter "kernel (hd0,0)/vmlinuz" and it finds the kernel. I would 
have expected this to be on (hd2,0).

Next, "boot root=/dev/md2", "boot root=/dev/hdc3" or "boot 
root=/dev/hda3" all result in the kernel booting then panicing with a 
"cannot open root device".

I suspect you are correct that the Fedora installer, having built and 
installed to RAID1, does not finish the job by installing grub on the 
second drive.

While it is not a problem with this particular box to do a reinstall, it 
does not inspire confidence for a number of others that I have.

This is the first time I have lost the primary member of a RAID1, having 
replaced secondary members a number of times without issue.

Regards,

Richard
