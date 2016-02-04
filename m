From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 1 needs repair
Date: Thu, 4 Feb 2016 11:45:06 -0500
Message-ID: <56B38012.5020404@turmel.org>
References: <285536573.454192.1454595669809.JavaMail.open-xchange@app01.ox.hosteurope.de>
 <56B36577.2030902@turmel.org>
 <1161942166.457494.1454601803851.JavaMail.open-xchange@app01.ox.hosteurope.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1161942166.457494.1454601803851.JavaMail.open-xchange@app01.ox.hosteurope.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Lamby <webmaster@peter-speer.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/04/2016 11:03 AM, Stefan Lamby wrote:
> Good morning Phil.
> I was hoping you are around - thanks for answering.
> The distro is a ubuntu lts server version 14.04.
> 
> I was able to chroot und grub-install /dev/sdb.
> The system is booting again. The md0-Array needs to be fixed now.
> 
> My docu for doing so is
> mdadm --manage /dev/md0 --fail /dev/sda1    # mark as failed
> mdadm --manage /dev/md0 --remove /dev/sda1  # remove failed disk from array
> mdadm --manage /dev/md0 --add /dev/sda1     # add new disk to array (assumed
> same or greater space for partition)
> 
> Can you confirm this?

You may also need "mdadm --zero-superblock /dev/sda1" before the add
command.

But if it's currently active in the array, why do you need to fail it?

Phil

