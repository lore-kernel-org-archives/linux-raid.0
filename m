From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: If your using large Sata drives in raid 5/6 ....
Date: Wed, 03 Feb 2010 13:24:57 +0100
Message-ID: <87r5p2v752.fsf@frosties.localdomain>
References: <87f94c371002021440o3b30414bk3a7ccf9d2fa9b8af@mail.gmail.com>
	<87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com>
	<alpine.DEB.1.10.1002031154250.31777@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1002031154250.31777@uplift.swm.pp.se> (Mikael
	Abrahamsson's message of "Wed, 3 Feb 2010 11:56:32 +0100 (CET)")
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike@swm.pp.se> writes:

> On Tue, 2 Feb 2010, Greg Freemyer wrote:
>
>> (I think these drives may already be available at least as
>> engineering samples.  Basic linux kernel support went in summer 2009
>> I believe. I believe 2.6.33 will be the first kernel to have been
>> tested with these new class of drives.)
>
> I purchased two WD20EARS drives yesterday, going to play around with
> them tonight. They emulate 512 bytes sectors to the SATA layer but
> write them as 4k on drive, so you want to make sure that everything
> that writes to the drive, writes in 4k block size (which is the case
> with most in linux as far as I have understood).
>
> So basically they'll work with any OS, but for best performance you
> need to make sure that things are aligned to 4k boundary and you want
> to write 4k at a time.

Make sure that your partitions are aligned then. Older partitioners will
start the first partition on block 63, meaning 32.5KiB into the disk.

MfG
        Goswin
