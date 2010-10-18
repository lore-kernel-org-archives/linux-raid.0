From: Tim Small <tim@seoss.co.uk>
Subject: Re: booting into /dev/md0 after an upgrade to squeeze
Date: Mon, 18 Oct 2010 20:49:02 +0100
Message-ID: <4CBCA4AE.5020504@seoss.co.uk>
References: <20101018201448.62a76ba6@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101018201448.62a76ba6@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/10/10 19:14, Janek Kozicki wrote:
> But, maybe do you have some experience with booting into raid1 /dev/md0
> after upgrading to squeeze?
>    

You can stop grub doing the root=uuid= thing by changing /etc/default/grub

If you can get someone to the keyboard, then you can probably get them 
to edit what grub is using as a one-off - i.e. change the root=uuid=xxx 
entry to root=/dev/md0 (or even just one half of the mirror if you need 
to get it working, then you can fix it later)...

It's also worth checking the contents of /etc/mdadm/mdadm.conf is 
sensible - maybe if you duplicated the partition (with dd maybe, if you 
said you duplicated the UUID), then it contains an incorrect uuid= line?

If it's incorrect, you may need to regenerate the initramfs having 
corrected it (a copy is placed in the initramfs files) with 
"update-initramfs -k all -u"

In a similar situations, where I have no remote console (IPMI SoL, Intel 
AMT etc.), I like to use "qemu -snapshot ..." to verify that a system 
will boot up correctly by pointing it at the real hard disks (see recent 
post to this list).

HTH,

Tim.

