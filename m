From: "Tom Fojta" <tj21@post.cz>
Subject: RE: RAID5 starts degraded after reboot
Date: Thu, 20 Sep 2007 16:00:31 +0200
Message-ID: <NCBBJOOHGLJMMINKAGGBIECGHFAB.tj21@post.cz>
References: <NCBBJOOHGLJMMINKAGGBCEAMHFAB.tj21@post.cz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <NCBBJOOHGLJMMINKAGGBCEAMHFAB.tj21@post.cz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I have created a 3 drive RAID5 array, but after each reboot it starts
> degraded with only 1 drive. It also changes the UUID of that drive. I have
> to manualy stop the array and force create it. I've seen similar
> problems in
> the archives but still have not found solution.

I have noticed that the array is assembled by initrd. So I updated it:

# dpkg-reconfigure --priority=low mdadm
update-initramfs: Generating /boot/initrd.img-2.6.18-5-686
I: mdadm: using configuration file: /etc/mdadm/mdadm.conf
I: mdadm: no MD arrays will be started from the initial ramdisk.
I: mdadm: use `dpkg-reconfigure --priority=low mdadm` to change this.

and selected not to assemble the array during boot. After reboot it works.

Tomas


