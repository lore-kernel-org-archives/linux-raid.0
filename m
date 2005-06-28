From: Patrik Jonsson <patrik@ucolick.org>
Subject: Trouble with SATA drives: "IRQ disabled"
Date: Tue, 28 Jun 2005 15:04:05 -0700
Message-ID: <42C1C955.9010302@ucolick.org>
References: <42A817B6.70709@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A817B6.70709@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have a machine running an array of 8 WD SATA drives, kernel 2.6.11.12 
patched with libata-devel to get smart working. I'm consistently getting 
these errors:

Jun 28 14:53:12 governator kernel: ata5: command 0xb0 timeout, stat 0xd0 
host_stat 0x0
Jun 28 14:53:12 governator kernel: ata5: status=0xd0 { Busy }
Jun 28 14:53:17 governator kernel: irq 185: nobody cared!
Jun 28 14:53:17 governator kernel:
Jun 28 14:53:17 governator kernel: Call Trace:<IRQ> 
<ffffffff80168e35>{__report_bad_irq+53} 
<ffffffff80168f0c>{note_interrupt+92}
Jun 28 14:53:17 governator kernel:        
<ffffffff801683c4>{__do_IRQ+628} <ffffffff8013b61e>{profile_tick+78}
Jun 28 14:53:17 governator kernel:        <ffffffff80111bb8>{do_IRQ+72} 
<ffffffff8010f0f3>{ret_from_intr+0}
Jun 28 14:53:17 governator kernel:         <EOI> 
<ffffffff80395d90>{unix_poll+0} <ffffffff8010cd50>{default_idle+0}
Jun 28 14:53:17 governator kernel:        
<ffffffff8010cd72>{default_idle+34} <ffffffff8010cdb5>{cpu_idle+53}
Jun 28 14:53:17 governator kernel:        
<ffffffff80552802>{start_kernel+466} <ffffffff80552243>{_sinittext+579}
Jun 28 14:53:17 governator kernel:       
Jun 28 14:53:17 governator kernel: handlers:
Jun 28 14:53:17 governator kernel: [<ffffffff88045000>] 
(nv_interrupt+0x0/0x1c0 [sata_nv])
Jun 28 14:53:17 governator kernel: [<ffffffff802f6f70>] 
(usb_hcd_irq+0x0/0x70)
Jun 28 14:53:17 governator kernel: Disabling IRQ #185
Jun 28 14:55:01 governator crond(pam_unix)[3349]: session opened for 
user root by (uid=0)
Jun 28 14:55:15 governator kernel: ata5: command 0xb0 timeout, stat 0x50 
host_stat 0x0
Jun 28 14:55:25 governator kernel: ata5: command 0xb0 timeout, stat 0x50 
host_stat 0x0
Jun 28 14:55:36 governator kernel: ata6: command 0xb0 timeout, stat 0x50 
host_stat 0x0
Jun 28 14:55:46 governator kernel: ata6: command 0xb0 timeout, stat 0x50 
host_stat 0x0

Does anyone have a clue what's going on here? I remember reading 
somewhere that the libata patch to get smart working was not "safe" 
because it did not make sure a command was already executing. Could that 
be what's going on? I'm using smart to log the temps of the drives every 
5 minutes.

Any ideas would be appreciated.

thanks,

/Patrik

