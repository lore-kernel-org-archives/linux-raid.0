From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: RAID5 temperorary loss two disk
Date: Thu, 29 Apr 2004 12:46:08 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87u0z3h573.fsf@enki.rimspace.net>
References: <408D0FF0.5000608@uni-mainz.de>
	<20040428142849.68073.qmail@web14525.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 28 Apr 2004, Don Jessup wrote:
> I have RAID5 volume that has two disk that have been marked as failed. 
> I believe this happen do to loss of communication with the disk. NOT
> because of a total disk failure. I assume if I can get the superblocks
> back into a good state I can reassemble the RAID5 and try to read what
> data I can off the volume. Does anyone know how to force RAID5
> superblocks into a state so I can do reads from the volume? I really
> need help on this. By the way the kernel version is 2.4.22.

mdadm has a --force option to the assemble command which I have used to
recover from a similar situation.  Don't forget to fsck the volume
afterwards, though, since it will have bad data on it.

            Daniel

-- 
The Believer had better face himself and ask squarely: Do I literally
believe "God" has a penis? If the answer is no, then it seems only
logical to drop the ridiculous practice of referring to "God" as "he."
        -- Robert Anton Wilson

