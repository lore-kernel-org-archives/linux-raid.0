From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Checking the sanity of SATA disks
Date: Tue, 4 Oct 2005 15:02:42 +0000
Message-ID: <62b0912f0510040802m5b417cb6s896f894859da8131@mail.gmail.com>
References: <20051004142913.GK6594@strugglers.net>
	 <62b0912f0510040742v3d0983b2mf5b93a17e8ed8bba@mail.gmail.com>
	 <20051004145608.GL6594@strugglers.net>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051004145608.GL6594@strugglers.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy Smith wrote:
> > Checked that the disks are using DMA transfers (use 'hdparm')?
>
> /dev/sda:
>  HDIO_GET_MULTCOUNT failed: Inappropriate ioctl for device

Oh, SATA; right.
You need a patch to make hdparm play well with SATA drives.
Ehrm, but I think that all SATAs run in DMA mode anyway, so never mind.

Sorry for the noise.

(Btw, what's with the "putting me in the Mail-Followup-To field" thingy?)
