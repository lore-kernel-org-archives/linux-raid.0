From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md_import_device returned -16 raid1
Date: Sun, 17 Jul 2005 09:08:25 +1000
Message-ID: <17113.37737.512268.68189@cse.unsw.edu.au>
References: <Pine.LNX.4.61.0507161534210.8523@hoss.npl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jim Radford on Saturday July 16
Sender: linux-raid-owner@vger.kernel.org
To: Jim Radford <jradford@npl.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 16, jradford@npl.com wrote:
> Greetings all:
> 
> Having a bit of difficulty with raid1, I built the array lastnight with 
> two new drives, and it built fine but when I rebooted I get the following 
> error when trying to start the array:
> 
> I'm running Mandrake 10.1 kernel 2.6.8.1-12mdk
> 
> [root@localhost jradford]# mdadm --version
> mdadm - v1.7.0 - 11 August 2004
> 
> [root@bengali jradford]# mdadm -A -s
> mdadm: failed to add /dev/hdc to /dev/md0: Device or resource busy

This is telling you that /dev/hdc is 'busy'.
Maybe a filesystem is mounted of it, or of a partition of it?

Could it already be in use?

NeilBrown
