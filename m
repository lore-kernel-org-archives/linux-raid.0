From: Warren Young <warren@etr-usa.com>
Subject: Re: Adaptec 7XXX/DPT SmartRAID V
Date: Thu, 31 Oct 2002 09:27:22 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DC159EA.2040304@etr-usa.com>
References: <334094430.20021030214559@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

gnu_is_not_unix wrote:
> 
> I got one problem with this configuration. When I try to boot from "my
> self" compiled kernel (2.4.18), as first controller, linux recognize DPT,
> so my root partitions can not be mounted (can not find root fs etc./etc.).

Two solutions: 1) compile the Adaptec 2940 driver into the kernel, and 
make the dpt_i2o driver a module.  This should force the 2940 to be seen 
first.  2) Make sure your scsi_adapter aliases are set up right in 
/etc/modules.conf, and re-generate your initrd.  They should set the 
detection order.

