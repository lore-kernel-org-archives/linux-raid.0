From: "bmoon" <bo@anthologysolutions.com>
Subject: 4k issue on MD device block size
Date: Thu, 15 May 2003 19:31:02 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <009001c31b53$32b36900$6901a8c0@bmoon>
References: <3EC3685E.3010202@cc.kuleuven.ac.be> <16067.28056.186816.649850@notabene.cse.unsw.edu.au> <3EC3A1D9.5010201@cc.kuleuven.ac.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Please provide me an advice on  the following issues;

I'd like to use 4k block size for both MD super block I/O and regular file
I/O,
which will improve the performance.

Q1: I noticed that it set the "blksize_size" to 4k for MD SB I/O but it use
1K
       for the regular file I/O.  It usually set the size to 1k at system
init by "md-init",
       then it set to 4k for MD SB I/O later. I could not find the place
that set it
      back to 1k.   However, it changes to 1 k????  How?

Q2: I modified md.c to use the 4k blksize_size. It works but sometimes it
crash.
      System "BLOCK_SIZE" is still 1k, and my hd device blksize_size=1k,
too.
      I changed ONLY 1024 to 4096 on every occurences on md.c.

     What am I missing?

Thanks in advance,

Bo


