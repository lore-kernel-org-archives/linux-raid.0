From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] Re: User space RAID-6 access
Date: Sat, 19 Feb 2011 00:02:38 +0100
Message-ID: <20110218230237.GA23883@lazy.lzy>
References: <20110131202054.GA15712@lazy.lzy>
 <20110201075259.4beaf501@notabene.brown>
 <20110205173334.GA5952@lazy.lzy>
 <20110206075820.08fc19c9@notabene.brown>
 <20110207222459.GA25471@lazy.lzy>
 <20110208094952.49745c7b@notabene.brown>
 <20110209184734.GA7169@lazy.lzy>
 <20110217172332.2fbb5694@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110217172332.2fbb5694@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> As this is really just for testing, I would add a :offset  suffix to the
> device names where the offset is in sectors.
> So:
>    /dev/sda
> means read from the start of /dev/sda
> 
>    /dev/sda:2048
> 
> means start 1Meg into /dev/sda.
> 
> That should be easy to parse and is quite general.

Hi again,

please find attached below another mini-patch
which should add the offset option, as discussed.
That is, "/dev/sdX:offset".
It should work with or without the ":offset" tail,
and possibly also with "/dev/sdX:", depending on
"atoll()".

Please consider for inclusion.

Thanks,

bye,


diff -uN a/restripe.c b/restripe.c
--- a/restripe.c	2011-02-18 23:18:20.377740868 +0100
+++ b/restripe.c	2011-02-18 23:30:07.589841525 +0100
@@ -875,6 +875,14 @@
 		exit(3);
 	}
 	for (i=0; i<raid_disks; i++) {
+		char *p;
+		p = strchr(argv[9+i], ':');
+
+		if(p != NULL) {
+			*p++ = '\0';
+			offsets[i] = atoll(p) * 512;
+		}
+			
 		fds[i] = open(argv[9+i], O_RDWR);
 		if (fds[i] < 0) {
 			perror(argv[9+i]);

-- 

piergiorgio
