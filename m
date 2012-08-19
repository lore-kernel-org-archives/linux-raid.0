From: Chris Murphy <lists@colorremedies.com>
Subject: Re: md raid behavior, bad sector uncorrectable read error
Date: Sun, 19 Aug 2012 12:12:38 -0600
Message-ID: <FEEB11B4-5CCB-49F4-8010-80CE03A49FA4@colorremedies.com>
References: <3E06D7FC-092A-4CB6-B79C-7EC94424DEEE@colorremedies.com> <CAGkViCFBqJJWeaA1Wrpc_BBw=wd1wV3nVrArEB51LJpJsrmsug@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGkViCFBqJJWeaA1Wrpc_BBw=wd1wV3nVrArEB51LJpJsrmsug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Aug 19, 2012, at 2:54 AM, Albert Pauw wrote:

> From what I know (and please correct me if I'm wrong), the drive
> happily remaps the sector to a different, spare, location.

Yes. Although there might be a difference between SATA and SAS handling, as SAS ECC is better by a lot. SATA ECC can return false corrections. Small problem.

For this thread, the context I'm curious about, is the detected but uncorrectable sector error. 

My understanding is that since the error is not corrected, the firmware won't remap the sector, but sets it as a pending sector remap until it receives a write command for that LBA. If the write is successful, pending status is removed. If the write persistently fails, the data is written to a reserved (good) sector which then gets that LBA and the bad sector is reserved (bad), no LBA. Since the LBA is the same, neither md nor the file system need to be informed of anything.

> Only when
> it can't do that it throws an error status back. Mind you, more than
> 10 years ago I had a scsi disk in a linux machine which suddenly broke
> down. Checking the logs I saw a lot of remap messages in the log in
> the weeks before. So it maybe that the drive gives warnings back up
> the controller chain.
> If this is true, what is md doing with this? If the remaps increase on
> that particular drive does i throw it out of the raid set?

What I'd like to see happen, is read errors cause chunk reconstruction from parity (or mirrored copy), and rewritten to disk. If it's just on-the-fly correction, without re-writing the chunk, then we'd need to run 'echo repair > /sys/block/mdX/md/sync_action' which would take an awfully long time in comparison.


On Aug 19, 2012, at 3:47 AM, Mikael Abrahamsson wrote:
> If I remember correctly from what has been described here before, a read error will cause a re-write with information created from parity

That's the thing I'd like to get a definitive answer one. If only it were easy to simulate bad sectors in VM's I could just test it!

> If it throws a write error, the drive is kicked from the array (because a drive with write errors is clearly defective).

That makes complete sense.



Chris Murphy