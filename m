From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: raid-1 with  ide-scsi emulation and mkswap failure
Date: Fri, 16 Apr 2004 11:27:35 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87wu4g4sqg.fsf@enki.rimspace.net>
References: <007401c422f0$baec4bc0$b100000a@M145Primary>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 15 Apr 2004, Eric Wood wrote:
> I did Warren's RAID-1 howto:
> http://togami.com/~warren/guides/remoteraidcrazies/
> ===========
> 1.  On this system I raid-1 /dev/hda and /dev/hdc together.
> 
> And I'm getting these errors during the copy process.
> hdc: dma_intr: error=0x84 { DriveStatusError BadCRC }
> hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }

Others have pointed out that ide-scsi shouldn't be the cause of this,
but no one seems to have noted the meaning of these errors.

Specifically, the BadCRC error says that the data transfer across the
IDE bus was corrupted, usually a sign that your data cable is too long.

You may want to look into that if this is more than a transient problem.

    Daniel

-- 
I have always detested the belief that sex is the chief bond
between man and woman. Friendship is far more human.
        -- Agnes Smedley

