From: Phil Turmel <philip@turmel.org>
Subject: Re: Question on md126 / md127 issues
Date: Sat, 28 May 2011 18:47:59 -0400
Message-ID: <4DE17B9F.8060909@turmel.org>
References: <BANLkTinePbV0qfs5XXy9cZQ2a7bQfO=FVQ@mail.gmail.com> <20110528073602.128cebc0@notabene.brown> <BANLkTimirBv2O_s91wKjf56OAt4m-iTnWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimirBv2O_s91wKjf56OAt4m-iTnWg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dylan,

On 05/28/2011 06:15 PM, Dylan Distasio wrote:
> Thanks, Neil.
> 
> I think running mkinitrd was probably the only thing required for a
> fix after reading your response.  I had an older array on the same box
> that was completely removed, but maybe something was leftover in
> initrd.
> 
> My detailed understanding of the initrd process is fairly limited.  I
> didn't realize there was a separate mdadm.conf that was used when
> booting that is separate from the one in /etc.

Many people miss this.  Modern linux distributions, with few exceptions, use a three stage boot process: 1) kernel, 2) initramfs, then 3) real root FS.  If there is no mdadm.conf in an initramfs at all, but the initramfs has raid support, mdadm will assemble everything it finds.  It will assign the first array to md127 and count backwards from there.

You might like this description of the process from the kernel docs:

http://www.kernel.org/doc/Documentation/filesystems/ramfs-rootfs-initramfs.txt

The money quote:

"An initramfs archive is a complete self-contained root filesystem for Linux."

If you change anything on your system that might impact the boot process, you're probably going to need to run "update-initramfs", or your distribution's equivalent.

HTH,

Phil
