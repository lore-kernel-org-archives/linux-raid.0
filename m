From: Pierre Beck <mail@pierre-beck.de>
Subject: Re: Areca hardware RAID / first-ever SCSI bus reset: am I about to
 lose this disk controller?
Date: Mon, 01 Oct 2012 23:33:15 +0200
Message-ID: <506A0BFB.60606@pierre-beck.de>
References: <87mx0lsv4d.fsf@spindle.srvr.nix> <FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com> <87r4pslpau.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87r4pslpau.fsf@spindle.srvr.nix>
Sender: linux-kernel-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Chris Murphy <lists@colorremedies.com>, Linux RAID <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Check the SMART values of the disks if possible. Watch for command 
timeouts and the usual bad sector stuff. I've had similar issues with 
Adaptec controllers. Bad disks seem to cause havoc. The outstanding 
operation isn't answered within [SCSI Timeout, default 30, 
/sys/block/sdX/device/timeout] seconds, so Linux performs a loop reset, 
eventually resetting the controller. That means between 60 and 120 
seconds of zero I/O operation, varying between controllers and disk 
array sizes. It's particularly annoying when in RAID and the disk 
could've simply been kicked within few seconds. Something that needs 
improvement IMHO.

On 23.09.2012 17:42, Nix wrote:
> On 19 Sep 2012, Chris Murphy outgrape:
>
>> On Sep 19, 2012, at 12:52 PM, Nix wrote:
>>
>>> So I have this x86-64 server running Linux 3.5.1 with a SATA-on-PCIe
>>> Areca 1210 hardware RAID-5 controller
>> Did you find this? Same controller family. Weird that this just shows
>> up now, but perhaps instead of it being "bad hardware" out the gate,
>> something's happened to it and now it's failing as you suspect.
> Hm, it's possible I suppose. Just as possible that a disk is dying.
>
>
> It looks to have been a one-off transient -- no recurrence yet, touch
> wood :)
>
