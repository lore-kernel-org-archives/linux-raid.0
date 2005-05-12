From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: MD bug or me being stupid?
Date: Thu, 12 May 2005 10:55:30 +0200
Message-ID: <62b0912f050512015585a6ba5@mail.gmail.com>
References: <62b0912f0504220345349335f9@mail.gmail.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0504220345349335f9@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

On 4/22/05, Molle Bestefich wrote:
> Just upgraded a MD RAID 5 box to 2.6.11 from 2.4.something.
> 
> Found out one disk was failing completely, got a replacement from Maxtor.  Neat.
> Replaced disk, rebooted..
> Added the new disk to the array with 'raidhotadd'.
> MD started syncing.
> 
> A couple of minutes into the process, it started *seriously* spamming
> the console with messages:
> 
> ==========================
> Apr 22 01:47:00 linux kernel: ..<6>md: syncing RAID array md1
> Apr 22 01:47:00 linux kernel: md: minimum _guaranteed_ reconstruction
> speed: 1000 KB/sec/disc.
> Apr 22 01:47:00 linux kernel: md: using maximum available idle IO bandwith (but
> not more than 200000 KB/sec) for reconstruction.
> Apr 22 01:47:00 linux kernel: md: using 128k window, over a total of
> 199141632 blocks.
> Apr 22 01:47:00 linux kernel: md: md1: sync done.
> Apr 22 01:47:00 linux kernel: ..<6>md: syncing RAID array md1
> Apr 22 01:47:01 linux kernel: md: minimum _guaranteed_ reconstruction
> speed: 1000 KB/sec/disc.
> Apr 22 01:47:01 linux kernel: md: using maximum available idle IO bandwith (but
> not more than 200000 KB/sec) for reconstruction.
> Apr 22 01:47:01 linux kernel: md: using 128k window, over a total of
> 199141632 blocks.
> Apr 22 01:47:01 linux kernel: md: md1: sync done.
> ==========================

[snip]

> afterwards, I can see that the above messages repeat themselves.
> cat /var/log/messages | grep md | grep 'Apr 22 01:47:01' | grep 'sync done'
> tells me that the messages were repeated 12 times per second.  The

Ping!...
Neil, just wondering, any comments regarding this particular endless loop in MD?
(Anything I can test or some such?)
