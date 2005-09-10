From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Fri, 9 Sep 2005 18:54:06 -0600 (MDT)
Message-ID: <Pine.LNX.4.63.0509091847520.4421@filesrv1.baby-dragons.com>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
 <Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
 <17184.43156.113155.811612@cse.unsw.edu.au>
 <Pine.LNX.4.63.0509081525380.30261@filesrv1.baby-dragons.com>
 <17184.56377.773388.978710@cse.unsw.edu.au>
 <Pine.LNX.4.63.0509082000030.31748@filesrv1.baby-dragons.com>
 <17185.15446.481054.508746@cse.unsw.edu.au> <Pine.LNX.4.63.0509091406070.2949@filesrv1.baby-dragons.com>
 <17186.852.375882.250912@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17186.852.375882.250912@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,

On Sat, 10 Sep 2005, Neil Brown wrote:
> On Friday September 9, babydr@baby-dragons.com wrote:
>>
>>  	Hello Neil ,  I patched all were successful .  But after a
>>  	make clean ; make
>>  	I get ...	Tia ,  JimL
>> ..snip...
>> gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=\"/etc/mdadm.conf\" -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\"   -c -o Assemble.o Assemble.c
>> Assemble.c: In function `Assemble':
>> Assemble.c:323: error: `nextspare' undeclared (first use in this function)
>> Assemble.c:323: error: (Each undeclared identifier is reported only once
>> Assemble.c:323: error: for each function it appears in.)
>> make: *** [Assemble.o] Error 1
>
> That's odd, as the patch contained:
>
> --- ./Assemble.c~current~	2005-09-05 10:55:01.000000000 +1000
> +++ ./Assemble.c	2005-09-09 16:24:50.000000000 +1000
> @@ -119,6 +119,7 @@ int Assemble(struct supertype *st, char
> 	struct mdinfo info;
> 	struct mddev_ident_s ident2;
> 	char *avail;
> +	int nextspare = 0;
>
> 	vers = md_get_version(mdfd);
> 	if (vers <= 0) {

 	What was missing from my 2.0 sources was the 'char *avail;'
 	and patching failed on that hunk ,  Which totally missed .
 	So I hand entered as you suggested the above bits .

 	Now it failes on a Warning (???) .
 	Never heard of failures on warnings before .

gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=\"/etc/mdadm.conf\" -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\"   -c -o Assemble.o Assemble.c
Assemble.c: In function `Assemble':
Assemble.c:121: warning: unused variable `avail'
make: *** [Assemble.o] Error 1

 	Would you please cut a source set to the kernel site >
 	Say as version 2.0a so I can see the diffs against the
 	sources I have ?  Tia ,  JimL

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
+------------------------------------------------------------------+
