From: Bernd Schubert <bernd-schubert@web.de>
Subject: Re: Checking consistency of Linux software RAID
Date: Mon, 7 Jul 2003 20:29:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307072029.14998.bernd-schubert@web.de>
References: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com>
Content-Disposition: inline
To: Martin Bene <martin.bene@icomedias.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 30 June 2003 14:58, Martin Bene wrote:
> Hi,
>
> Administrationg quite a few systems with HW raid controllers, I've come to
> really like a feature that seems to be missing from current SW raid:
>
> Scheduling a (weekly) complete media scan where all surfaces of all drives
> get read; in case of read errors a repair is tried: the content for the
> failed sector is reconstructed just as if the drive had completely failed
> and rewritten to the failed sector; if reading works afterwards, regard the
> repair as successfull and continue using the drive.
>
> Is there any way to do this with SW raid? I truly hate situations where
> some sectors on a drive fail silently and you don't notice until a 2nd
> drive dies and you find you can't recostruct your raid data becaus of
> silent "bitrot".
>

Hi,

/proc/mdstat is to monitor the status of your raid, so when one drive fails it 
becomes dropped out of the raid-array. Using mdadm you can monitor 
/proc/mdstat and it even can send you a mail when one of your disks fails. So 
if you really want to scan your disk once a week, why not running 'dd 
if=/dev/mdX of=/dev/zero' ? So every block of every raid-disk should become 
read and the md-driver should automatically drop a failing disk  out of the 
raid. 
I guess you could even try to repair a disk when it became dropped out of the 
raid by running some scripts, but since I never trusted any disk that had 
failed ones, I never worried about it.

Bernd
