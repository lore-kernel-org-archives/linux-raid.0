From: "Sandra Escandor" <sescandor@evertz.com>
Subject: Issues with auto assembling or RAID10 (imsm) on boot
Date: Mon, 20 Jun 2011 15:02:16 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFAD36F3E@otis.burlington.evertz.tv>
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

I'm using Ubuntu 10.10 + mdadm 3.1.4. I have my raid described in
/etc/mdadm/mdadm.conf:

HOMEHOST <system>    
ARRAY metadata=imsm UUID=46e68921:eea24d1d:e933eee8:192d55bc
ARRAY /dev/md/Volume0 container=46e68921:eea24d1d:e933eee8:192d55bc
member=0  
UUID=b39c8d9d:ab2fcd08:f4559292:981754f1

I have also done the following:
update-initramfs -k all -u

BUT my RAID does not automatically assemble upon boot. I actually have
to run the following on the command line:

sudo mdadm -As

in order for the RAID to initialize. I read that you are supposed to run
that update-initramfs command if you change your mdadm.conf, but it
appears that it didn't really do anything. What am I missing?

Thanks,
Sandra
