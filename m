From: Maarten J H van den Berg <maarten@vbvb.nl>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 3 Mar 2004 03:36:51 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403030336.51772.maarten@vbvb.nl>
References: <4045288B.27321.2DA4EF3@localhost> <404532F6.8743.303008B@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <404532F6.8743.303008B@localhost>
Content-Disposition: inline
To: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 03 March 2004 02:20, Chris Evans wrote:
> On 3 Mar 2004 at 2:11, Maarten J H van den Berg wrote:

Neil had some interesting points, but in the meantime here's my working 
lilo.conf (which was written by the SuSE installer) in case it helps you:

boot = /dev/hda
change-rules
    reset
default = linux
disk=/dev/hda
    bios=0x80
    disk=/dev/hdc
    bios=0x81
lba32
prompt
read-only
timeout = 80

image = /boot/vmlinuz
    label = linux
    initrd = /boot/initrd
    root = /dev/md0


Greetings,
Maarten

