From: "Sandra Escandor" <sescandor@evertz.com>
Subject: Newb question: Auto assembling of RAID10 (imsm) on boot
Date: Mon, 20 Jun 2011 08:33:57 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFAD36E05@otis.burlington.evertz.tv>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm using mdadm 3.1.4 (built from source) and I have a
/etc/mdadm/mdadm.conf with the following:


HOMEHOST Volume0

ARRAY /dev/md/imsm_container metadata=imsm UUID=...

ARRAY /dev/md/Volume0 container=.... Member = 0 UUID=...

 

And I can assemble the array on command line like so: mdadm -As.
 
but, I am not too sure what I should do with the initramfs in order for
the system to recognize that it should actually assemble the RAID when
it boots. What I've done is the following: 
After I changed my /etc/mdadm/mdadm.conf, I did an update-initramfs -k
all -u.
I did a: zcat /boot/initrd.img-2.6.35-28-generic | cpio -idv into a
/tmp/initrd folder,
but I didn't see a etc/mdadm/mdadm.conf under the /tmp/initrd folder
that I created. I also restarted the server to see if I would be able to
see /dev/md* that should be there if the RAID has been auto-assembled,
but it didn't exist on startup. I had to assemble the array on the
command-line...What am I missing?
 
Thanks,
Sandra
