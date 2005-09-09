From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Sat, 10 Sep 2005 07:49:08 +1000
Message-ID: <17186.852.375882.250912@cse.unsw.edu.au>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
	<Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
	<17184.43156.113155.811612@cse.unsw.edu.au>
	<Pine.LNX.4.63.0509081525380.30261@filesrv1.baby-dragons.com>
	<17184.56377.773388.978710@cse.unsw.edu.au>
	<Pine.LNX.4.63.0509082000030.31748@filesrv1.baby-dragons.com>
	<17185.15446.481054.508746@cse.unsw.edu.au>
	<Pine.LNX.4.63.0509091406070.2949@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Friday September 9
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday September 9, babydr@baby-dragons.com wrote:
> 
>  	Hello Neil ,  I patched all were successful .  But after a
>  	make clean ; make
>  	I get ...	Tia ,  JimL
> ..snip...
> gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=\"/etc/mdadm.conf\" -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\"   -c -o Assemble.o Assemble.c
> Assemble.c: In function `Assemble':
> Assemble.c:323: error: `nextspare' undeclared (first use in this function)
> Assemble.c:323: error: (Each undeclared identifier is reported only once
> Assemble.c:323: error: for each function it appears in.)
> make: *** [Assemble.o] Error 1

That's odd, as the patch contained:

--- ./Assemble.c~current~	2005-09-05 10:55:01.000000000 +1000
+++ ./Assemble.c	2005-09-09 16:24:50.000000000 +1000
@@ -119,6 +119,7 @@ int Assemble(struct supertype *st, char 
 	struct mdinfo info;
 	struct mddev_ident_s ident2;
 	char *avail;
+	int nextspare = 0;
 	
 	vers = md_get_version(mdfd);
 	if (vers <= 0) {


Maybe add that bit in by hand??

NeilBrown
