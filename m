From: Morten Sylvest Olsen <mso@medical-insight.com>
Subject: documentation of /sys/vm/max-readahead
Date: Mon, 6 Dec 2004 22:42:06 +0100 (CET)
Message-ID: <20041206222336.B61850@arsenium.medical-insight.com>
References: <20041206174851.GA521@hamachi.dyndns.org>
 <200412061929.iB6JTj904159@www.watkins-home.com> <20041206211607.GA3037@hamachi.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041206211607.GA3037@hamachi.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list.

Am I the first to battle performance related issues from the setting of
/proc/sys/vm/max-readahead? It seems there is quite a few threads floating
around the net related to performance of the md driver with external disks
connected over FC.

But I was pretty confused because /proc/mdstat reports the bogus old
device read_ahead value, and the md driver silently (well, not really)
uses /sys/vm/max-readahead to calculate a window size which makes quite a
difference in my setup where I have some scsi disks on a relatively
high-latency SAN. Possibly this issue only shows itself when running
RAID-1 where the chunksize is not used (there seem to be a bug in Jacob's
howto in section 5.10 on that point)

Maybe the issue only arises on RedHat because they for some reason chose
to make the 31 default value of /proc/sys/vm/max-readahead in their EL3
release, where the older default of 127 is more resonable?

I don't mind writing the blurb myself, if I'm not totally off course in my
error diagnostics.

-- Morten
--
Morten Sylvest Olsen, System Developer
Medical Insight A/S, Hovedgaden 451 C,2640 Hedehusene, Denmark
Phone:+4546550444, Mobile:+4551573092,Mail: mso@medical-insight.com

