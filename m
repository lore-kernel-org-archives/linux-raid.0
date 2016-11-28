From: "Randall C. Grimshaw" <rgrimsha@esf.edu>
Subject: RE: md prefered minor has been renumbered
Date: Mon, 28 Nov 2016 22:10:59 +0000
Message-ID: <BC4985417D7F7B49B9AB545333BDB61B191FE263@Exchange-MBX1.esf.edu>
References: <BC4985417D7F7B49B9AB545333BDB61B191FE1A2@Exchange-MBX1.esf.edu>
 <BC4985417D7F7B49B9AB545333BDB61B191FE1BC@Exchange-MBX1.esf.edu>,<91b64061-6026-c738-75a6-8d80a177aec8@turmel.org>,<BC4985417D7F7B49B9AB545333BDB61B191FE20C@Exchange-MBX1.esf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BC4985417D7F7B49B9AB545333BDB61B191FE20C@Exchange-MBX1.esf.edu>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Update: So I was really hopeful given the google find of this link:
http://superuser.com/questions/346719/how-to-change-the-name-of-an-md-device-mdadm
as instructed I stopped my devices, that went well.
mdadm --stop /dev/md122
mdadm --assemble --update=super-minor /dev/md5 /dev/sdb7 /dev/sda7
but the --assemble command errors with the message: no devices found for /dev/md5
note: the devices /dev/sda7 and /dev/sda7 *DO* appear with fdisk -l

do I need to --force the command or something?

Randall
________________________________________
From: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org] on behalf of Randall C. Grimshaw [rgrimsha@esf.edu]
Sent: Monday, November 28, 2016 3:34 PM
To: Phil Turmel; linux-raid@vger.kernel.org
Subject: RE: md prefered minor has been renumbered

Phil:
  Thank you for responding, it is much appreciated.
  This is a recently assigned system so I must apologize for not having all of the history re fstab.
  But when I try to boot into the 'normal' system it continues to use the new numbering, the mounts fail, (the duplicate md122 obviously fails), and the system panics.
  I suspect the answer will have something to do with the command I googled: mdadm -A --update=superminor /dev/mdNEWNUMBER  /dev/sd...
. but I have zero experience with it.
Randall

________________________________________
From: Phil Turmel [philip@turmel.org]
Sent: Monday, November 28, 2016 2:58 PM
To: Randall C. Grimshaw; linux-raid@vger.kernel.org
Subject: Re: md prefered minor has been renumbered

On 11/28/2016 12:26 PM, Randall C. Grimshaw wrote:
> I have made the mistake of booting a centos-6.8 live cd to manipulate a centos 5 system.
> as a result md5 has become md122, md2 has become md125, md4 has become md126, md0 has become md127, and most unfortunately md3 has also become md122.

This is normal and expected for a livecd -- the numbering comes from the
mdadm.conf file in the initramfs, unless that mdadm.conf file excludes
arrays for later assembly (when the rootfs is available).

Many livecd initramfs scripts try to assemble everything, so the numbers
are allocated from 127 down.  Usually you can find a boot parameter to
suppress assembly.

> smartctl shows that the WD brand drives do support SCT
> mdadm --examine was used to reveal the mish-mash using uuid numbers compared with the file /etc/mdadm.conf also referencing /etc/fstab.

Eww.  You should not be counting on /dev/mdX numbering in your fstab.
Specifically for this reason.  Use LABEL= or UUID= syntax in fstab.

> can someone kindly tell me the mdadm command to put the correct numbers back.

No need.  When you boot back into your normal system, its initramfs will
supply this information.  If you are changing the info, make sure you
rebuild your initramfs, so the updated mdadm.conf file is included.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
