From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Areca hardware RAID / first-ever SCSI bus reset: am I about to lose this disk controller?
Date: Mon, 1 Oct 2012 16:46:20 -0600
Message-ID: <2A7CFE69-08F3-4C53-928C-A94907027CAC@colorremedies.com>
References: <87mx0lsv4d.fsf@spindle.srvr.nix> <FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com> <87r4pslpau.fsf@spindle.srvr.nix> <506A0BFB.60606@pierre-beck.de>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <506A0BFB.60606@pierre-beck.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


On Oct 1, 2012, at 3:33 PM, Pierre Beck wrote:
> It's particularly annoying when in RAID and the disk could've simply been kicked within few seconds. Something that needs improvement IMHO.

Except that while this helps with faster recovery, you're now degraded. You wouldn't want this "fast recovery" behavior if you're at your critical number of disks remaining or you lose the array upon a few seconds worth of subsequent problems. So we kinda need context specific behavior.


Chris Murphy