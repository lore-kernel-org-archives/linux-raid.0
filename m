From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Redhat8 software RAID0 and kernel upgrade, won't boot
Date: Tue, 18 Mar 2003 10:43:54 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E773EBA.7B1D9868@SteelEye.com>
References: <20030318152750.95214.qmail@web14402.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Brennahn Chesteine <ven_ficken@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brennahn Chesteine wrote:
 
> Well, 2.4.20 built without error and installed clean.
> I said yes to RAID support and built everything under
> that as a module. 

Red Hat compiles md into the kernel, not as a module. Could that be what
the problem is?


> Rebooted and whola there 2.4.20 was as an option.
> Selected it and thins went to churning..... PANIC
> cannot find root. I have read and read about have to
> voodoo the lilo.conf file to make it work but have
> found zilch on grub.

If your /boot is not on software RAID, I don't think anything special
needs to be done with the boot loader...

--
Paul
