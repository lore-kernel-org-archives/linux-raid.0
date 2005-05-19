From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Thu, 19 May 2005 09:14:02 -0700
Message-ID: <428CBB4A.8080900@h3c.com>
References: <428A09A3.9000802@heyjay.com> <428A81FB.1070201@home.se> <428CB19B.8010402@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428CB19B.8010402@heyjay.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jay Strauss <me@heyjay.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


That's more like what we were expecting!

I can't tell you why its like that or how, but this *is* the typical
problem with IDE. Most likely the chipset is being detected incorrectly,
or its being detected correctly but there is some errata that's
disabling dma, or maybe dma is experimental for the card.

Places to look for information are in the dmesg for the sis chipset's
detection diagnostics, then on the internet as a google for your sis
chipset number then "linux dma" maybe. You may end up with some ide
things on your kernel command line (via grub or lilo)

I'll reiterate something I said previously though, other than
write-caching (which is potentially dangerous) none of the other hdparm
or IDE settings are really going to give you that much of a boost unless
your workload is specifically tunable. They're all just little minor
twiddles you can do - nothing even close to the difference between
having DMA or not. So I'd just focus on enabling DMA. The other stuff is
all uninteresting compared to it.

-Mike

Jay Strauss wrote:
> Hi (again):
> 
> I diff'ed the contents of /proc/ide of Knoppix and Sarge, there were a
> couple of (possibly) interesting differences.  I'm not sure how to go
> about changing the settings.  The net/net is on my controller under
> knoppix it says UDMA Enabled but on Sarge it's disabled.  Also the
> writecache is enabled under knoppix (I did a hdparm -W 1 /dev/hda, but
> my tests were identical)
> 
> Below are the diffs,  I'd like to make the sarge install setting
> identical, and see if that changes anything.
> 
> If anyone knows how to alter these settings, I'd be appreciated
> 
> thanks
> Jay
> 
> jstrauss@hydrogen:~$ diff -r sarge.ide/sis knoppix.ide/sis
> 10,11c10,11
> <                 UDMA Enabled                   UDMA Enabled
> <                 UDMA Cycle Time    2 CLK       UDMA Cycle Time    4 CLK
> ---
>>                 UDMA Disabled                          UDMA Disabled
>>                 UDMA Cycle Time    Reserved    UDMA Cycle Time Reserved
> 
> and
> jstrauss@hydrogen:~$ diff sarge.ide/hda/settings knoppix.ide/hda/settings
> 7a8
>> breada_readahead        8               0               255    rw
> 9c10
> < current_speed           68              0              
> 70              rw
> ---
>> current_speed           12              0               70    rw
> 11c12,13
> < init_speed              68              0              
> 70              rw
> ---
>> file_readahead          124             0               16384    rw
>> init_speed              12              0               70    rw
> 16c18,19
> < multcount               0               0              
> 16              rw
> ---
>> max_kb_per_request      128             1               255    rw
>> multcount               16              0               16    rw
> 20a24
>> slow                    0               0               1    rw
> 23c27
> < wcache                  1               0              
> 1               rw
> ---
>> wcache                  0               0               1    rw
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
