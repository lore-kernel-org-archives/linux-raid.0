From: "John Stoffel" <john@stoffel.org>
Subject: Re: start dm-multipath before mdadm raid
Date: Thu, 10 Dec 2015 11:28:02 -0500
Message-ID: <22121.43026.985668.789870@quad.stoffel.home>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Remek" <p.remek1@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


P> I am trying to create mdadm raid on top of dm-multipath devices.
P> Everything works but after reboot the mdadm array is assembled from
P> the original (not multipath devices) devices and the multipath
P> devices are not created at all.

Can you give more details about the OS, kernel version and
configuration of the setup?  

It sounds like you have some local disks and some remote disks that
you want to use in the RAID.  But it's not clear how you're setting
things up.

P> Aparently it is because the mdadm software raid is started before
P> the dm-multipath creates the multipathed devices. Is there a way
P> how to make the dm-multipath start before the mdadm is started?

Hmm... I think devicemapper should be starting pretty early.  Do you
have your initramfs setup properly?  You might need to setup things so
they are working properly, the do:

     update-grub2

to make sure the initramfs gets properly updated.  You might also want
to make sure that LVM is compiled into your kernel, but MDADM is a
module, which should force them to be started in the proper order.

But really, you need to provide details.  Can you setup a small test
MD RAID and show all the details?

John
