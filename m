From: Clive Messer <clive@vacuumtube.org.uk>
Subject: Re: RAID-5 recovery
Date: Mon, 4 Sep 2006 00:41:16 +0100
Message-ID: <200609040041.16420.clive@vacuumtube.org.uk>
References: <200609031148.56910.clive@vacuumtube.org.uk> <Pine.LNX.4.64.0609031530010.12203@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0609031530010.12203@twinlark.arctic.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Linux List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday 03 September 2006 23:32, you wrote:
> On Sun, 3 Sep 2006, Clive Messer wrote:
> > This leads me to a question. I understand from reading the linux-raid
> > archives that the current behaviour when rebuilding with a single
> > badblock on another disk is for that disk to also be kicked from the
> > array.
>
> that's not quite the current behaviour.  since 2.6.14 or .15 or so md will
> reconstruct bad blocks from other disks and try writing them.  it's only
> when this fails repeatedly that it knocks the disk out of the array.

That's interesting, but I'm running Fedora Core 5 and the kernel was 2.6.17.
The scenario was that in a 4 disk RAID-5 array (sda,sdb,sdc,sdd), sda was 
failed from the array. When adding it back the reconstruction got to about 
5%, at which point sdb was failed from the array due to repeated 'medium 
error'. ie. reconstructing sda caused data to be read from sdb. I ran 
badblocks on sdb - it had 3 badblocks. sdc and sdd had none.
Would you have expected this behaviour? Or is it the case that md can only try 
and recover badblocks from other disks when the array has not already been 
degraded?

Regards

Clive
-- 
Clive Messer <clive@vacuumtube.org.uk>

-- 
VGER BF report: H 0.00128114
