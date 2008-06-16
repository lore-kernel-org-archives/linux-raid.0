From: Michal Soltys <soltys@ziu.info>
Subject: Re: Confused about UUID mounting and mirrors
Date: Mon, 16 Jun 2008 22:41:05 +0200
Message-ID: <4856CFE1.1020105@ziu.info>
References: <4856A8C6.3030609@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4856A8C6.3030609@kmaclub.com>
Sender: linux-raid-owner@vger.kernel.org
To: "michael@kmaclub.com" <michael@kmaclub.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

michael@kmaclub.com wrote:
> Hello,
> 
> This confuses mount at boot time.
> 
> How to I get it to correctly find md0 and not the components of the mirror?
> 

You mean you mount by /dev/disk/by-uuid/* ?

The 0.9x or 1.0 superblocks (the ones working nicely with grub and 
raid1) are placed at the end of the device, thus existing filesystem can 
be detected both from /dev/sd{a,b}1 and /dev/md0.

In such case, you will have to adjust udev rules, so sd{a,b}1 filesystem 
uuid symlinks will not be created, or will be overwritten by the symlink 
to /dev/md0.

You can achieve the latter with higher link_priority in OPTIONS, in your 
udev rules.

