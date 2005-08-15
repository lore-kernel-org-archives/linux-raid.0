From: "Gary Guthary" <gguthary@jtech.net>
Subject: Problem compiling 'raidtools'
Date: Tue, 16 Aug 2005 03:03:39 +0900
Message-ID: <200508151800.j7FI0RAY001903@ns.jtech.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Sir(s),

I recently ran into a problem compiling the 'raidtools-1.00.3.tar.gz'
tarball.

While my older Linux system (using 'gcc ver. 3.2.3) would compile the
software (although complaining about 'mkraid.c' long 'literal'), my newest
Linux box (Slack 10.1 w/gcc ver 3.3.4) would not.

This is because the source file, 'mkraid.c', has a VERY LOOOONG string
literal from about line #172 to about line #198. - While 'depreciated' in my
older compiler, my newer one 'errors out'. - It won't work.

To fix this problem, all I did was to add a '\n\' (backslash-n-backslash) to
the end of each line of this long 'literal'. - After that it compiled okay.

I saved my file as 'mkraid.c.bugfix'. - I also duped a copy of your
'mkraid.c' as 'mkraid.c.orig' (in case folks make a mistake 'copying' or
'moving'). - I then made a new file called 'README.BUGFIX explaining in
detail what I did', & I added a small entry to your README telling folks to
see the 'README.BUGFIX' if they have problems.

Lastly - I created a new tarball out of the whole thing & put it on my
server for download. - If you want to see what I did, here it is:

www.jtech.net/software/raidtools-1.00.3.bugfix.tar.gz

I guess using the word 'bugfix' is probably inappropriate. - Because there
aren't any bugs that I could find. - But I had to call it something.

I apologize if I'm 'stepping on toes', but I'd thought you'd like to know
this for perhaps future releases.

If you already know about this, please forgive me.

Respectfully,

Gary Guthary



