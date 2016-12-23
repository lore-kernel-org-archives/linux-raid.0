From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: SAS disk from RAID card (no RAID mode) problems
Date: Fri, 23 Dec 2016 09:21:35 -0500
Message-ID: <wrfja8bmiv4g.fsf@redhat.com>
References: <2326bdf0-2948-5cbf-3033-27ed41803e23@imagedworld.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2326bdf0-2948-5cbf-3033-27ed41803e23@imagedworld.com> (IW News's
        message of "Fri, 23 Dec 2016 09:01:40 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: IW News <news@imagedworld.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

IW News <news@imagedworld.com> writes:
> Hello,
>
> First message here.
>
> After looking for a solution without any luck I have found this
> list. I hope someone can help me with this.
>
> I have an ASUS P6T Deluxe with a MARVELL 88SE63xx SAS RAID controller.
> There are to identical 400GB SAS SSD drives attached to it. One of
> them has a Windows 10 installation, the other one Linux.
> Grub is installed on the second disk.
>
> Windows works as expected, but I have problems with the Linux
> installation: the desktop environment freezes for some second once in
> a while. This occurs with Mint Cinnamon, OpenSuSe KDE, Ubuntu and
> Manjaro KDE. All of them are current installations. I'm now working in
> up to date Manjaro KDE (kernel 4.9.0).
> When the temporary freezes occur the mouse pointer moves, some windows
> are updated correctly, other do not and DE stops working.
> When this happens always I have a system log like this:
>
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
[snip]
> Sometimes shorter sometimes larger.
> It looks like a controller/drive/cable problem?
> Any thoughts?

Doesn't look like a Linux RAID issue, but much more like a driver
problem. Possibly caused by cables or controller issues.

You probably want to reach out to the linux-scsi list.

Jes
