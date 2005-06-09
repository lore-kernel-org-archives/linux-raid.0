From: Piete Brooks <Piete.Brooks@cl.cam.ac.uk>
Subject: Re: Is there a good reason why I can't "mdadm -Gfn1 /dev/md1" ?
Date: Thu, 09 Jun 2005 12:40:37 +0100
Message-ID: <E1DgLOn-0004TI-00@mta2.cl.cam.ac.uk>
References: <E1DgFzi-0007K9-00@mta2.cl.cam.ac.uk> <17064.9218.919914.356958@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: Message from Neil Brown <neilb@cse.unsw.edu.au>
   of "Thu, 09 Jun 2005 21:12:02 +1000." <17064.9218.919914.356958@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Piete Brooks <Piete.Brooks@cl.cam.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hmmm.... yes... Didn't think of that did I?

I know the feeling :-(

> I'm very close to releasing mdadm 1.12.0.  It will have this fixed.

Thanks.

> If you are impatient, the patch against 1.11.0 is very simple.  See below.
> +		case O(GROW,'f'): /* ditto */

That was exactly the patch I applied, apart from the comment, and I put it one 
line higher :-))
( I really meant "Is there a good reason not to, as I have already done it"!)


The next thing I stumbled over was:

       When  reducing the number of devices in a RAID1 array, the slots which
       are to be removed from the array must already be vacant.

Is there a command to "move this device to another slot"? I'm stuck with:

	md8 : active raid1 sdb8[1]
	      4208896 blocks [2/1] [_U]

which I can't reduce to a one way mirror as it's in slot 1 not 0 :-((



Are you interested in problems compiling under 64b?
I fixed the first using a simple "(int)", but I'm not up enough on how what 
long long unsigned int should mean with different length words that I just 
chopped the "-Werror" so I could test it ...

gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=\"/etc/mdadm.conf\" -ggdb 
-DSendmail=\""/usr/sbin/sendmail -t"\"   -c -o bitmap.o bitmap.c
bitmap.c: In function `bitmap_fd_read':
bitmap.c:130: warning: int format, different type arg (arg 3)
bitmap.c:171: warning: long long unsigned int format, __u64 arg (arg 3)
bitmap.c: In function `ExamineBitmap':
bitmap.c:241: warning: long long unsigned int format, __u64 arg (arg 2)
bitmap.c:242: warning: long long unsigned int format, __u64 arg (arg 2)
bitmap.c:247: warning: long long unsigned int format, __u64 arg (arg 2)
make: *** [bitmap.o] Error 1

