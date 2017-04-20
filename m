From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: IMSM RAID10: Rebuild/Resync difference on Linux vs Windows
Date: Thu, 20 Apr 2017 12:06:15 +0200
Message-ID: <19c14cad-6322-fc13-780f-bb82ca8db20b@intel.com>
References: <055fbb58-fb5f-5d69-0974-aaa234c99028@binary-island.eu>
 <4f749c02-3478-cafc-2ae4-40af25459f65@intel.com>
 <01c2b1cd-1893-d299-5907-0b5be5f13776@binary-island.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01c2b1cd-1893-d299-5907-0b5be5f13776@binary-island.eu>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Dahl <ml_linux-raid@binary-island.eu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/20/2017 09:44 AM, Matthias Dahl wrote:
> Hello Artur...
> 
> So, the same thing happened again yesterday: The RAID10 was out of sync
> due to an unclean shutdown and while Linux was at 70.8% of the resync, I
> restarted to Win 10 with RST 15.2.0.1020 and it recognized the RAID as
> clean without any visible/noticeable verification at all.
> 
> I did a manual verification run in Win this time, just for the sake of
> it, and it came up fine.
> 
> Nevertheless, this really has me worried. Did you get / see my last mail
> with the information you requested?
> 
> By the way, kernel version was 4.10.8 with mdadm/mdmon 4.0.

Hi Matthias,

This really is strange, I'll try to ask someone from the Windows RST
team about this. Unfortunately I don't have any knowledge about the
Windows driver. I saw your earlier email and everything looked OK there.

Does this happen only when you reboot to Windows? Have you ever rebooted
during resync again to Linux and did resync resume as expected? Also,
have you noticed what state did the BIOS show for the array when you
rebooted? I'm asking because this might not be caused by Windows but
maybe the BIOS/UEFI driver or Linux not updating the metadata properly
at shutdown.

Thanks,
Artur
