From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md: bug in file md.c, line 1440 (2.4.22)
Date: Wed, 3 Sep 2003 10:47:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16213.14893.955734.797630@gargle.gargle.HOWL>
References: <3F5017CA.4080700@tomt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Tomt on Saturday August 30
To: Andre Tomt <andre@tomt.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, mingo@redhat.com
List-Id: linux-raid.ids

On Saturday August 30, andre@tomt.net wrote:
> Heya :-)
> 
> Having a funny showstopper problem here with md, the autostart fails 
> miserably with "md: bug in file md.c, line 1440"
> 
> Here's the story;
and a sad one it is...

> md:	**********************************
> md:	* <COMPLETE RAID STATE PRINTOUT> *
> md:	**********************************
> md5: <hda9> array superblock:
> md:  SB: (V:0.90.0) ID:<80012e77.b449af86.6bccffae.ddda9474> CT:3e4caa02
> md:     L1 S24394560 ND:-22 RD:2 md5 LO:0 CS:32768
> md:     UT:3f50117d ST:1 AD:2 WD:2 FD:-24 SD:0 CSUM:a62f39ca E:0000006d
>      D  0:  DISK<N:0,hdc9(22,9),R:0,S:6>
>      D  1:  DISK<N:1,hda9(3,9),R:1,S:6>
>      D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
>      D  3:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
>      D  4:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>

Your problem is that these extra slots (N:0) are flagged as failed
(S:9) and this confuses md.c.

If you get mdadm 1.3.0 and apply the three patches that can be found
in
   http://cgi.cse.unsw.edu.au/~neilb/source/mdadm/patch/applied/

and then stop the array and use:
   mdadm --assemble --update=summaries /dev/md5 /dev/sda9 /dev/sdc9

then it should fix things up for you.
You will need to do a similar thing for all of the arrays.
This will be difficult for md2 as it is 'root'.  You will need to boot
a rescue disc to fix this one.

I have not idea how it got the failed flag.

NeilBrown
