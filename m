From: "NeilBrown" <neilb@suse.de>
Subject: Re: Raid and badblocks
Date: Fri, 22 May 2009 21:50:58 +1000 (EST)
Message-ID: <77f027ed892f0a37b3df63d574ae7955.squirrel@neil.brown.name>
References: <gv5q3p$vof$1@ger.gmane.org> <gv5qnk$1pe$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <gv5qnk$1pe$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 22, 2009 7:19 pm, Jeremy Sanders wrote:
> PS, here are some more data from the logs:
> .....
> sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
> sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error
> end_request: I/O error, dev sdj, sector 1953103080
                                          ^^^^^^^^^^
> Buffer I/O error on device sdj, logical block 244137885
                                                ^^^^^^^^^
> md: requested-resync of RAID array md0
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000
> KB/sec) for requested-resync.
> md: using 128k window, over a total of 976551040 blocks.
                                         ^^^^^^^^^
> md: md0: requested-resync done.

Consider those three underlined numbers.

The first is the (512byte) sector number of the error:
   1953103080
The second is the 4K block number.  Multiply by 8 to get sector number
and we get
   1953103080
exactly the same.  That is encouraging.

The third is the number of 1K blocks that the array covers.
So double that to get sectors and the answer is
   1953102080

So that erroneous sector is 1000 sectors (500K) beyond the end of
the data area of the array.  i.e. it is in the unused padding at the end,
possibly near where the metadata lives.

So md/raid5 will never touch that block.

If you want to write to it which might make the drive think it isn't
bad any more, you could
   dd if=/dev/zero of=/dev/sdj seek=1953103080 count=1

But if it were me, I would do
   dd if=/dev/sdj of=/dev/null skip=1953103080 count=1
and confirm that gives and error, just to double check the numbers.

NeilBrown


