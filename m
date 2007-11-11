From: David Greaves <david@dgreaves.com>
Subject: Re: Raid5 assemble after dual sata port failure
Date: Sun, 11 Nov 2007 22:49:49 +0000
Message-ID: <4737870D.5000906@dgreaves.com>
References: <47321FDF.8060207@synplicity.com> <4732E5F0.7080805@dgreaves.com> <4734CFE5.8070305@synplicity.com> <4734FB4A.4070401@synplicity.com> <473576F9.6040602@dgreaves.com> <4735FC7E.7030601@synplicity.com> <47373746.9090701@dgreaves.com> <47373EB9.9050408@synplicity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47373EB9.9050408@synplicity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Eddington <chrise@synplicity.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Eddington wrote:
> Yes, there is some kind of media error message in dmesg, below.  It is
> not random, it happens at exactly the same moments in each xfs_repair -n
> run.
> Nov 11 09:48:25 altair kernel: [37043.300691]          res
> 51/40:00:01:00:00/00:00:00:00:00/e1 Emask 0x9 (media error)
> Nov 11 09:48:25 altair kernel: [37043.304326] ata4.00: ata_hpa_resize 1:
> sectors = 976773168, hpa_sectors = 976773168
> Nov 11 09:48:25 altair kernel: [37043.307672] ata4.00: ata_hpa_resize 1:
> sectors = 976773168, hpa_sectors = 976773168

I'm not sure what an ata_hpa_resize error is...

It probably explains the problems you've been having with the raid not 'just
recovering' though.

I saw this:
http://www.linuxquestions.org/questions/linux-kernel-70/sata-issues-568894/


What does smartctl say about your drive?

IMO the spare drive is no longer useful for data recovery - you may want to use
ddrescue to try and copy this drive to the spare drive.

David
PS Don't get the ddrescue parameters the wrong way round if you go that route...
