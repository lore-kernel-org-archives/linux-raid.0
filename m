From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 09:21:59 +1100
Message-ID: <16859.5895.203013.789777@cse.unsw.edu.au>
References: <l1nna2-e9i.ln1@news.it.uc3m.es>
	<20050104024108.GK99565@caffreys.strugglers.net>
	<895qa2-0qa.ln1@news.it.uc3m.es>
	<200501042002.32292.maarten@ultratux.net>
	<j6dra2-9vs.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Tuesday January 4
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 4, ptb@lab.it.uc3m.es wrote:
> 
> Uh, that's not at issue. The question is whether it is CORRECT, not
> whether it is consistent.
> 

What exactly do you mean by "correct".

If I have a program that writes some data:
   write(fd, buffer, 8192);
and then makes sure the data is on disk:
   fsync(fd);

but the computer crashes sometime between when the write call started
and the fsync called ended, then I reboot and read back that block of
data from disc, what is the "CORRECT" value that I should read back?

The answer is, of course, that there is no one "correct" value.
It would be correct to find the data that I had tried to write.  It
would also be correct to find the data that had been in the file
before I started the write.  If the size of the write is larger than
the blocksize of the filesystem, it would also be correct to find a
mixture of the old data and the new data.

Exactly the same is true at every level of the storage stack.  There
is a point in time where a write request starts, and a point in time
where the request is known to complete, and between those two times
the content of the affected area of storage is undefined, and could
have any of several (probably 2) "correct" values.

After an unclean shutdown of a raid1 array, every (working) device
has correct data on it.  They may not all be the same, but they are
all correct.

md arbitrarily chooses one of these correct values, and replicates it
across all drives.  While it is replicating, all reads are served by
the chosen drive.

NeilBrown
