From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing Soft RAID under Linux)
Date: Sun, 28 May 2006 19:48:26 +0200
Message-ID: <20060528174826.GK8203@percy.comedia.it>
References: <17526.41252.855793.479011@cse.unsw.edu.au> <20060528133203.GC8203@percy.comedia.it> <Pine.LNX.4.64.0605281004010.30550@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0605281004010.30550@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 28, 2006 at 10:08:19AM -0700, dean gaudet wrote:
>On Sun, 28 May 2006, Luca Berra wrote:
>
>> - mdadm-2.5-rand.patch
>> Posix dictates rand() versus bsd random() function, and dietlibc
>> deprecated random(), so switch to srand()/rand() and make everybody
>> happy.
>
>fwiw... lots of rand()s tend to suck... and RAND_MAX may not be large 
>enough for this use.  glibc rand() is the same as random().  do you know 
the fact that glibc rand() is the same implementation as random() was one of the
reason i believe we could switch to rand()

>if dietlibc's rand() is good enough?
dietlibc rand() and random() are the same function.
but random will throw a warning saying it is deprecated.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
