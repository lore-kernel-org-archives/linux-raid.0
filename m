From: Tyler <pml@dtbb.net>
Subject: Re: BUGREPORT: mdadm v2.0-devel - can't create array using version
 1 superblock, possibly related to previous bugreport
Date: Tue, 03 May 2005 18:36:27 -0700
Message-ID: <4278271B.1020408@dtbb.net>
References: <42775D47.4000805@dtbb.net> <17016.3902.917012.297224@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17016.3902.917012.297224@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I've gotten past the device being busy using the patch, and onto a new 
error message and set of problems:

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdb
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdd
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -C -l 5 -n 3 -e 1 
/dev/md0 /dev/hdb /dev/hdc /dev/hdd
VERS = 9002
mdadm: ADD_NEW_DISK for /dev/hdb failed: Invalid argument
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdb
/dev/hdb:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 02808c44c0:1a8f4351:d5dc7f68:fe2e4c
           Name :
  Creation Time : Wed May  4 02:31:48 2005
     Raid Level : raid5
   Raid Devices : 3

    Device Size : 390721952 (186.31 GiB 200.05 GB)
   Super Offset : 390721952 sectors
          State : active
    Device UUID : 02808c44c0:1a8f4351:d5dc7f68:fe2e4c
    Update Time : Wed May  4 02:31:48 2005
       Checksum : 7462e130 - correct
         Events : 0

         Layout : -unknown-
     Chunk Size : 64K

   Array State : Uu_ 380 spares 2 failed
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdd

And the following in Dmesg:
md: hdb has invalid sb, not importing!
md: md_import_device returned -22

So it would seem that a bad superblock gets written to the first device, 
then the program bails, leaving the bad superblock (that was blank 
before), and doesn't finish.  Mdadm is unable to zero this superblock 
either, as i posted earlier, even after multiple attempts.  I did manage 
to erase it using 'dd if=/dev/zero of=/dev/hdb bs=64k seek=3050000' to 
seek near the end of the drive and erase it, but thats when I ran the 
above steps, coming to the same problem each time.

Thanks,
Tyler.

Neil Brown wrote:

>On Tuesday May 3, pml@dtbb.net wrote:
>  
>
>>When i try to create any raid5/raid6 array with --metadata 1 or 
>>--metadata 1.0, it simply spits out a response saying /dev/hdX is 
>>busy... X being whichever drive i listed as an array member first on the 
>>list of drives.
>>    
>>
>
>Yes .... thanks for the very clear bug report.  Some clumsy developer
>forgot to close the file, didn't that :-(
>Patch below.
>
>NeilBrown
>
>
>
>### Diffstat output
> ./super1.c |    9 +++++++--
> 1 files changed, 7 insertions(+), 2 deletions(-)
>
>diff ./super1.c~current~ ./super1.c
>--- ./super1.c~current~	2005-05-04 09:45:24.000000000 +1000
>+++ ./super1.c	2005-05-04 09:52:34.000000000 +1000
>@@ -496,11 +496,15 @@ static int write_init_super1(struct supe
> 		free(refsb);
> 	}
>     
>-	if (ioctl(fd, BLKGETSIZE, &size))
>+	if (ioctl(fd, BLKGETSIZE, &size)) {
>+		close(fd);
> 		return 1;
>+	}
> 
>-	if (size < 24)
>+	if (size < 24) {
>+		close(fd);
> 		return 2;
>+	}
> 
> 
> 	/*
>@@ -540,6 +544,7 @@ static int write_init_super1(struct supe
> 	rv = store_super1(fd, sb);
> 	if (rv)
> 		fprintf(stderr, Name ": failed to write superblock to %s\n", devname);
>+	close(fd);
> 	return rv;
> }
> 
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

