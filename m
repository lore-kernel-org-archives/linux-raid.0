From: jlcenter@comcast.net
Subject: Re: Install grub2 to /dev/md126 fails
Date: Wed, 4 Jan 2012 01:35:10 +0000 (UTC)
Message-ID: <2012259890.359354.1325640910810.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
References: <4F02DEA3.4050901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F02DEA3.4050901@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: "Jes Sorensen" <Jes.Sorensen@redhat.com>

Did your raid device(s) get added to /boot/grub2/device.map correctly?
If not, does it install properly if you add the devices there manually?

I've had a pile of problems with grub2 on Fedora, including something
like this.


Hi Jes,

When I tried to create the device.map file, it only added the individual disks, not the raid devices.  I then tried to add them by hand, but I kept getting an error whenever it hit the raid1 volume.  What did you see & how did you resolve it?

Thanks.

    -John
