From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: resync on every raidstart
Date: Tue, 23 Sep 2003 16:47:26 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16239.60542.191148.816664@notabene.cse.unsw.edu.au>
References: <7e6d.3f6de874.1ece7@altium.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dick Streefland on Sunday September 21
To: Dick Streefland <dick.streefland@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday September 21, dick.streefland@xs4all.nl wrote:
> Every time I stop a RAID1 device with raidstop, and start it again
> with raidstart, it resyncs. Is this normal, or am I doing something
> wrong? Here is an example with a RAID1 device on two loopback
devices:

I cannot reproduce this.
Does it happen with real devices, or only loopback devices?

Can you try with mdadm and see if that makes a difference?

After raidstop, and before raidstart, can you

  mdadm -E /dev/loop1
  mdadm -E /dev/loop2

and show me the results?

Thanks,
NeilBrown
