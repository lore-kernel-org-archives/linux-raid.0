From: Nix <nix@esperi.org.uk>
Subject: Re: Areca hardware RAID / first-ever SCSI bus reset: am I about to lose this disk controller?
Date: Sun, 23 Sep 2012 16:41:29 +0100
Message-ID: <87r4pslpau.fsf@spindle.srvr.nix>
References: <87mx0lsv4d.fsf@spindle.srvr.nix>
	<FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com> (Chris
	Murphy's message of "Wed, 19 Sep 2012 14:19:29 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 19 Sep 2012, Chris Murphy outgrape:

>
> On Sep 19, 2012, at 12:52 PM, Nix wrote:
>
>> So I have this x86-64 server running Linux 3.5.1 with a SATA-on-PCIe
>> Areca 1210 hardware RAID-5 controller 
>
> Did you find this? Same controller family. Weird that this just shows
> up now, but perhaps instead of it being "bad hardware" out the gate,
> something's happened to it and now it's failing as you suspect.

Hm, it's possible I suppose. Just as possible that a disk is dying.


It looks to have been a one-off transient -- no recurrence yet, touch
wood :)

-- 
NULL && (void)
