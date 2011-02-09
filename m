From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] Re: User space RAID-6 access
Date: Wed, 9 Feb 2011 19:47:34 +0100
Message-ID: <20110209184734.GA7169@lazy.lzy>
References: <20110131202054.GA15712@lazy.lzy>
 <20110201075259.4beaf501@notabene.brown>
 <20110205173334.GA5952@lazy.lzy>
 <20110206075820.08fc19c9@notabene.brown>
 <20110207222459.GA25471@lazy.lzy>
 <20110208094952.49745c7b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110208094952.49745c7b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I have applied some patch - with some formatting changes to make it consistent
> with the rest of the code.
> 
> I don't really have time to look more deeply at it at the moment.
> Maybe someone else will?...

Hi Neil,

thanks for including this in git.

Actually I did it look at it :-) and I already found a
couple of issues, below is a small fix patch.

One question about offsets.
I noticed that offsets seems to be defined per component,
in the md software stack.
I mean, looking at sysfs, the offset are inside md/dev-sdX/offset
or available with mdadm -E /dev/sdX
It seems possible that different components have different
offset (I can imagine this happening with different sizes).

Now, from inside "test_stripe" there is no information about
the RAID itself, I mean the device, nor about the metadata type.

What would be the best way to get the offsets inside "restripe.c"?

1) popen "mdadm -E ..." and grep the "Data Offset" field.
2) pass one single offset as command line parameter.
3) add the whole md device as command line parameter, removing
the single devices, and use sysfs.

Thanks for any advice,

bye,

pg


diff -uN a/restripe.c b/restripe.c
--- a/restripe.c	2011-02-09 19:31:18.989495816 +0100
+++ b/restripe.c	2011-02-09 19:32:42.597955058 +0100
@@ -430,7 +430,8 @@
 
 
 		if((Px != 0) && (Qx != 0)) {
-			data_id = (raid6_gflog[Qx] - raid6_gflog[Px]) & 0xFF;
+			data_id = (raid6_gflog[Qx] - raid6_gflog[Px]);
+			if(data_id < 0) data_id += 255;
 			diskD = geo_map(data_id, start/chunk_size,
 					data_disks + 2, level, layout);
 			curr_broken_disk = diskD;
@@ -439,6 +440,9 @@
 		if((Px == 0) && (Qx == 0))
 			curr_broken_disk = curr_broken_disk;
 
+		if(curr_broken_disk >= data_disks + 2)
+			broken_status = 2;
+
 		switch(broken_status) {
 		case 0:
 			if(curr_broken_disk != -1) {
@@ -450,10 +454,6 @@
 		case 1:
 			if(curr_broken_disk != prev_broken_disk)
 				broken_status = 2;
-
-			if(curr_broken_disk >= data_disks + 2)
-				broken_status = 2;
-
 			break;
 
 		case 2:
 
bye,

-- 

piergiorgio
