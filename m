From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 13:56:27 +0100
Message-ID: <bb145bd20803020456g54be4bcbg1cf7aed132ac7944@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <alpine.DEB.1.00.0803020741150.13994@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0803020741150.13994@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

>  Disable NCQ and your problem will go away.

Thank you. Just out of interest - which problem and why?

>  echo 1 > /sys/block/$i/device/queue_depth

I get access denied even as root. FWIW the value is at 1 for the 4
disks in the raid anyway. The SCSI disk has value 8, which is probably
irrelevant.

For completeness' sake:

mdadm version: mdadm - v2.6.4 - 19th October 2007
raid setup command: mdadm --create /dev/md0 --verbose --metadata=1.0
--homehost=jesus -n4 -c1024 -l5 --bitmap=internal --name tb-storage
-ayes /dev/sd[bcde]
cryptsetup command: cryptsetup luksFormat /dev/md0 --align-payload=2048

Any other suggestions on any of the issues?

Thanks,

C.
