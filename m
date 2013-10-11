From: Brian Candler <b.candler@pobox.com>
Subject: Re: Using mdadm instead of dmraid for BIOS-RAID root volume
Date: Fri, 11 Oct 2013 20:49:22 +0100
Message-ID: <52585642.6000005@pobox.com>
References: <5253F7C2.2030401@pobox.com> <52541473.4020005@pobox.com> <52545092.1040001@arcor.de> <5257F706.8050708@pobox.com> <52583FC1.1070107@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52583FC1.1070107@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 > Maybe, but your setup is pretty unusual. These MD arrays are "disks" 
for the installer, and thus would need to be partitioned. I believe it 
would work better that way. I have never tried an LVM PV on a whole disk.

It wouldn't let me partition md125 either. It just did nothing when I 
clicked "Edit".

