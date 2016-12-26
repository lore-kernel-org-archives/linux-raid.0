From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: SAS disk from RAID card (no RAID mode) problems
Date: Mon, 26 Dec 2016 14:25:11 -0700
Message-ID: <1567104.jAPptYD2GZ@natasha>
References: <2326bdf0-2948-5cbf-3033-27ed41803e23@imagedworld.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2326bdf0-2948-5cbf-3033-27ed41803e23@imagedworld.com>
Sender: linux-raid-owner@vger.kernel.org
To: IW News <news@imagedworld.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday, December 23, 2016 9:01:40 AM MST IW News wrote:
> Hello,
> 
> First message here.
> 
> After looking for a solution without any luck I have found this list. I
> hope someone can help me with this.
> 
> I have an ASUS P6T Deluxe with a MARVELL 88SE63xx SAS RAID controller.
> There are to identical 400GB SAS SSD drives attached to it. One of them
> has a Windows 10 installation, the other one Linux.
> Grub is installed on the second disk.
> 
> Windows works as expected, but I have problems with the Linux
> installation: the desktop environment freezes for some second once in a
> while. This occurs with Mint Cinnamon, OpenSuSe KDE, Ubuntu and Manjaro
> KDE. All of them are current installations. I'm now working in up to
> date Manjaro KDE (kernel 4.9.0).
> When the temporary freezes occur the mouse pointer moves, some windows
> are updated correctly, other do not and DE stops working.
> When this happens always I have a system log like this:

If thats the mvsas driver, god help you. I had nothing but troubles with it 
for a good year or two or possibly more and it was never fixed or really 
acknowledged, so I sold that card (a supermicro aoc-saslp-mv8) and picked up a 
IBM m1015 (LSI 9211-8i a-like) and haven't looked back.

Basically it would reset a lot, and lock up. AND I believe it caused a lot of 
silent corruption as well.

> ______________________________________________________
> 23/12/16 8:29    kernel    sas: Enter sas_scsi_recover_host busy: 6
> failed: 6
> 23/12/16 8:29    kernel    sas: trying to find task 0xffff8bda8d2bd900
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
> 0xffff8bda8d2bd900
> 23/12/16 8:29    kernel    sas: task done but aborted
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
> 0xffff8bda8d2bd900 is done
> 23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
> 0xffff8bda8d2bd900 is done
> 23/12/16 8:29    kernel    sas: trying to find task 0xffff8bda8d2bce00
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
> 0xffff8bda8d2bce00
> 23/12/16 8:29    kernel    sas: task done but aborted
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
> 0xffff8bda8d2bce00 is done
> 23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
> 0xffff8bda8d2bce00 is done
> 23/12/16 8:29    kernel    sas: trying to find task 0xffff8bda8d2bd700
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
> 0xffff8bda8d2bd700
> 23/12/16 8:29    kernel    sas: task done but aborted
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
> 0xffff8bda8d2bd700 is done
> 23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
> 0xffff8bda8d2bd700 is done
> 23/12/16 8:29    kernel    sas: trying to find task 0xffff8bda8d2bde00
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
> 0xffff8bda8d2bde00
> 23/12/16 8:29    kernel    sas: task done but aborted
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
> 0xffff8bda8d2bde00 is done
> 23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
> 0xffff8bda8d2bde00 is done
> 23/12/16 8:29    kernel    sas: trying to find task 0xffff8bda8d2bdc00
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
> 0xffff8bda8d2bdc00
> 23/12/16 8:29    kernel    sas: task done but aborted
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
> 0xffff8bda8d2bdc00 is done
> 23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
> 0xffff8bda8d2bdc00 is done
> 23/12/16 8:29    kernel    sas: trying to find task 0xffff8bdcb0298800
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
> 0xffff8bdcb0298800
> 23/12/16 8:29    kernel    sas: task done but aborted
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
> 0xffff8bdcb0298800 is done
> 23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
> 0xffff8bdcb0298800 is done
> 23/12/16 8:29    kernel    sas: --- Exit sas_scsi_recover_host: busy: 0
> failed: 6 tries: 1
> 23/12/16 8:29    kernel    drivers/scsi/mvsas/mv_sas.c 1694:reuse same
> slot, retry command.
> 23/12/16 8:29    kernel    drivers/scsi/mvsas/mv_sas.c 1694:reuse same
> slot, retry command.
> 23/12/16 8:29    kernel    drivers/scsi/mvsas/mv_sas.c 1694:reuse same
> slot, retry command.
> 23/12/16 8:29    kernel    sas: Enter sas_scsi_recover_host busy: 2
> failed: 2
> 23/12/16 8:29    kernel    sas: trying to find task 0xffff8bdb9453ae00
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
> 0xffff8bdb9453ae00
> 23/12/16 8:29    kernel    sas: task done but aborted
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
> 0xffff8bdb9453ae00 is done
> 23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
> 0xffff8bdb9453ae00 is done
> 23/12/16 8:29    kernel    sas: trying to find task 0xffff8bdb9453b000
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: aborting task
> 0xffff8bdb9453b000
> 23/12/16 8:29    kernel    sas: task done but aborted
> 23/12/16 8:29    kernel    sas: sas_scsi_find_task: task
> 0xffff8bdb9453b000 is done
> 23/12/16 8:29    kernel    sas: sas_eh_handle_sas_errors: task
> 0xffff8bdb9453b000 is done
> 23/12/16 8:29    kernel    sas: --- Exit sas_scsi_recover_host: busy: 0
> failed: 2 tries: 1
> ____________________________________________________________________________
> ______________
> 
> Sometimes shorter sometimes larger.
> It looks like a controller/drive/cable problem?
> Any thoughts?
> 
> Thanks in advance.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
