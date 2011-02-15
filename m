From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Tue, 15 Feb 2011 14:37:55 -0500
Message-ID: <4D5AD613.3040402@turmel.org>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown> <4D5A92F3.1090004@turmel.org> <4D5ACE4B.9040309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5ACE4B.9040309@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/15/2011 02:04 PM, Simon McNair wrote:
> Phil,
> Thanks for filling in the gaps, I had forgotton quite how much help and assistance you had provided up to now.  You're a real godsend.
> 
> To fill in some of the other pieces of info:
> The original machine was called proxmox (KVM virtualisation machine) and I used an Ubuntu live cd to see if it was the software which was preventing progress or not.  It does seem like there is data corruption in the machine name for some reason.
> 
> The original company I ordered the controller through sent me an email at 4pm saying that they could not fulfill the order, 4pm was too late for them to pick & pack so there was another 24hr turn around delay.  The supermicro card should arrive here tomorrow and hopefully I'll be able to get a dd of each of the drives prior to Phil coming online.
> 
> For some reason blkid doesn't exist on my machine even though I have e2fs-utils installed.  V weird.

FWIW, on my VPS running Ubuntu Server 10.10, the blkid executable is part of util-linux, and installed in /sbin.  You might need to re-install it.

Phil
