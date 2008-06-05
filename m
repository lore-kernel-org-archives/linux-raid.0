From: Michal Soltys <soltys@ziu.info>
Subject: Re: boot time autoassembly: how come it works?
Date: Thu, 05 Jun 2008 07:10:44 +0200
Message-ID: <48477554.7090409@ziu.info>
References: <4847119C.3070002@jellybean.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4847119C.3070002@jellybean.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jules Bean wrote:
> I'm trying to understand the boot sequence of new kernels (2.6.24, 
> initramfs) better and I really don't understand how the RAID assembly 
> works.
> 
> The docs (md.txt) say that auto-assembly only occurs if the RAID arrays 
> are marked as 'RAID autodetect' aka partition type 0xfd. On the other 
> hand mdadm needs mdadm.conf to get going.
> 

Initramfs is a tiny linux. It (usually) either has simple mdassamble or 
mdassemble.auto, or full-blown mdadm - and when you use those, partition 
type is ignored.

Partitions with 0xfd relate to [deprecated in times of early userpsace] 
method of assembling the arrays by the kernel itself, before any 
userspace code (initramfs/rd, your system) takes action.
