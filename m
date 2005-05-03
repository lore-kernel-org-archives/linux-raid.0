From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: BUGREPORT: mdadm v2.0-devel - can't create array using version 1
 superblock, possibly related to previous bugreport
Date: Wed, 4 May 2005 09:54:38 +1000
Message-ID: <17016.3902.917012.297224@cse.unsw.edu.au>
References: <42775D47.4000805@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tyler on Tuesday May 3
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 3, pml@dtbb.net wrote:
> When i try to create any raid5/raid6 array with --metadata 1 or 
> --metadata 1.0, it simply spits out a response saying /dev/hdX is 
> busy... X being whichever drive i listed as an array member first on the 
> list of drives.

Yes .... thanks for the very clear bug report.  Some clumsy developer
forgot to close the file, didn't that :-(
Patch below.

NeilBrown



### Diffstat output
 ./super1.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff ./super1.c~current~ ./super1.c
--- ./super1.c~current~	2005-05-04 09:45:24.000000000 +1000
+++ ./super1.c	2005-05-04 09:52:34.000000000 +1000
@@ -496,11 +496,15 @@ static int write_init_super1(struct supe
 		free(refsb);
 	}
     
-	if (ioctl(fd, BLKGETSIZE, &size))
+	if (ioctl(fd, BLKGETSIZE, &size)) {
+		close(fd);
 		return 1;
+	}
 
-	if (size < 24)
+	if (size < 24) {
+		close(fd);
 		return 2;
+	}
 
 
 	/*
@@ -540,6 +544,7 @@ static int write_init_super1(struct supe
 	rv = store_super1(fd, sb);
 	if (rv)
 		fprintf(stderr, Name ": failed to write superblock to %s\n", devname);
+	close(fd);
 	return rv;
 }
 
