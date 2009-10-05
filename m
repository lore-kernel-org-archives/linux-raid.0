From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/1] md: drivers/md/unroll.pl replaced with awk analog
Date: Tue, 6 Oct 2009 09:54:05 +1100
Message-ID: <19146.30989.928233.393339@notabene.brown>
References: <4aca1863.0a1ad00a.33bf.1017@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755589AbZJEWxu@vger.kernel.org>
In-Reply-To: message from Vladimir Dronnikov on Monday October 5
Sender: linux-kernel-owner@vger.kernel.org
To: Vladimir Dronnikov <dronnikov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, rob@landley.net, firmware@impactlinux.com
List-Id: linux-raid.ids

On Monday October 5, dronnikov@gmail.com wrote:
> From: Vladimir Dronnikov <dronnikov@gmail.com>
> 
> drivers/md/unroll.pl replaced by awk script to drop build-time dependency on perl

Thanks for the patch,
and thanks to Rob Landley for the pointer to where this was discussed
elsewhere.  The change makes sense to me.

Just a couple of little changes needed:

>  quiet_cmd_unroll = UNROLL  $@
> -      cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
> +      cmd_unroll = awk -f$(srctree)/$(src)/unroll.awk -vN=$(UNROLL) \
>                     < $< > $@ || ( rm -f $@ && exit 1 )
>  

The top level Makefile defines
AWK          = awk

so I think $(AWK) should be used here, rather than a literal 'awk'.


> --- linux-2.6.31.orig/drivers/md/raid6test/Makefile	Wed Sep  9 22:13:59 2009
> +++ linux-2.6.31/drivers/md/raid6test/Makefile	Mon Oct  5 20:10:15 2009
> @@ -7,7 +7,7 @@
>  OPTFLAGS = -O2			# Adjust as desired
>  CFLAGS	 = -I.. -I ../../../include -g $(OPTFLAGS)
>  LD	 = ld
> -PERL	 = perl
> +AWK	 = awk
>  AR	 = ar
>  RANLIB	 = ranlib
>  
> @@ -35,35 +35,35 @@
>  raid6test: test.c raid6.a
>  	$(CC) $(CFLAGS) -o raid6test $^
>  
> -raid6altivec1.c: raid6altivec.uc ../unroll.pl
> -	$(PERL) ../unroll.pl 1 < raid6altivec.uc > $@
> +raid6altivec1.c: raid6altivec.uc ../unroll.awk
> +	$(AWK) ../unroll.awk 1 < raid6altivec.uc > $@

In the md/Makefile, you pass the unroll count as
      -vN=$NUMBER

in raid6test/Makefile you pass it as just
      $NUMBER

one of these is wrong.  Which one?

Well.....

> --- /dev/null	Thu Jan  1 00:00:00 1970
> +++ linux-2.6.31/drivers/md/unroll.awk	Mon Oct  5 20:12:24 2009
> @@ -0,0 +1,20 @@
> +
> +# This filter requires one command line argument (n) which must be a
> +# decimal number.

According to the comment, "$NUMBER" is correct. But

> +#
> +# Repeat each input line containing $$ n times, replacing $$ with 0...n-1.
> +# Replace each $# with n, and each $* with a single $.
> +
> +BEGIN {
> +	n = N + 0
> +}

according to the code  "-vN=$NUMBER" is correct.

So you need to fix either the code or the comment, then fix one of the
two Makefiles.

You might like to try running the test in raid6test as well, just to 
triple check that it all still works.

Thanks,
NeilBrown


> +{
> +	if (/\$\$/) { rep = n } else { rep = 1 }
> +	for (i = 0; i < rep; ++i) {
> +		tmp = $0
> +		gsub(/\$\$/, i, tmp)
> +		gsub(/\$\#/, n, tmp)
> +		gsub(/\$\*/, "$", tmp)
> +		print tmp
> +	}
> +}
> --- linux-2.6.31.orig/drivers/md/unroll.pl	Wed Sep  9 22:13:59 2009
> +++ /dev/null	Thu Jan  1 00:00:00 1970
> @@ -1,24 +0,0 @@
> -#!/usr/bin/perl
> -#
> -# Take a piece of C code and for each line which contains the sequence $$
> -# repeat n times with $ replaced by 0...n-1; the sequence $# is replaced
> -# by the unrolling factor, and $* with a single $
> -#
> -
> -($n) = @ARGV;
> -$n += 0;
> -
> -while ( defined($line = <STDIN>) ) {
> -    if ( $line =~ /\$\$/ ) {
> -	$rep = $n;
> -    } else {
> -	$rep = 1;
> -    }
> -    for ( $i = 0 ; $i < $rep ; $i++ ) {
> -	$tmp = $line;
> -	$tmp =~ s/\$\$/$i/g;
> -	$tmp =~ s/\$\#/$n/g;
> -	$tmp =~ s/\$\*/\$/g;
> -	print $tmp;
> -    }
> -}
