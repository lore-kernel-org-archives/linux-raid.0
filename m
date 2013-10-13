From: Brian Candler <b.candler@pobox.com>
Subject: Re: Using mdadm instead of dmraid for BIOS-RAID root volume
Date: Sun, 13 Oct 2013 19:12:05 +0100
Message-ID: <525AE275.9010804@pobox.com>
References: <5253F7C2.2030401@pobox.com> <52541473.4020005@pobox.com> <52545092.1040001@arcor.de> <5257F706.8050708@pobox.com> <52583FC1.1070107@arcor.de> <52585642.6000005@pobox.com> <525ACE00.8090105@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <525ACE00.8090105@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/10/2013 17:44, Martin Wilck wrote:
> On 10/11/2013 09:49 PM, Brian Candler wrote:
>>   > Maybe, but your setup is pretty unusual. These MD arrays are "disks"
>> for the installer, and thus would need to be partitioned. I believe it
>> would work better that way. I have never tried an LVM PV on a whole disk.
>>
>> It wouldn't let me partition md125 either. It just did nothing when I
>> clicked "Edit".
> I assume that that has something to do with the pre-exisiting PV.
There were two md volumes: one was an existing PV; one had been used an 
existing ext4 filesystem natively, and was neither partitioned nor a PV.

The one which was ext4 did nothing when I tried to partition it (by 
clicking the "Edit..." button). The one which was a PV gave an error 
when I tried to edit it (fair enough). But then after I removed all the 
LVs and the VG, clicking "Edit..." on that one no longer gave an error, 
but it just did nothing.

> what you describe is "just" an
> anaconda problem.
True enough.

