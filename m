From: Neil Brown <neilb@suse.de>
Subject: Re: raidtools to mdadm
Date: Mon, 2 Apr 2007 10:07:41 +1000
Message-ID: <17936.18765.324284.750028@notabene.brown>
References: <46103C8B.4030001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Casey Boone on Sunday April 1
Sender: linux-raid-owner@vger.kernel.org
To: Casey Boone <caseyboone@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday April 1, caseyboone@gmail.com wrote:
> as best i can tell i am using the correct commands for what i want but i 
> pretty much get nothing but errors:
> 
> root@Knoppix:/media# mdadm --build /dev/md1 --chunk=128 --level=0 
> --raid-devices=2 /dev/sda /dev/sdb
> mdadm: error opening /dev/md1: No such device or address

"No such device or address" probably means that the md module is not
loaded. 
  modprobe md
or
  modprobe md_mod

and try again.

NeilBrown
