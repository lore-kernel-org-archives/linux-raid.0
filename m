From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm-2.5.4 issues and 2.6.18.1 kernel md issues
Date: Thu, 9 Nov 2006 16:32:01 +1100
Message-ID: <17746.48465.156017.828602@cse.unsw.edu.au>
References: <1162479503.2898.338.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Thursday November 2
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday November 2, dledford@redhat.com wrote:
> If I use mdadm 2.5.4 to create a version 1 superblock raid1 device, it
> starts a resync.  If I then reboot the computer part way through, when
> it boots back up, the resync gets cancelled and the array is considered
> clean.  This is against a 2.6.18.1 kernel.

I cannot reproduce that (I tried exactly 2.6.18.1).
Do you have kernel logs of the various stages?

> 
> If I create a version 1 superblock raid1 array, mdadm -D <constituent
> device> says that the device is not part of a raid array (and likewise
> the kernel autorun facility fails to find the device).

   mdadm -D <constituent device>
is incorrect usage.  You want
   mdadm -E <constituent device>
or
   mdadm -D <assembled array>

in-kernel autorun does not work with version 1 metadata as it does not
store a 'preferred minor'.

> 
> If I create a version 1 superblock raid1 array, mdadm -E <constituent
> device> sees the superblock.  If I then run mdadm -E --brief on that
> same device, it prints out the 1 line ARRAY line, but it misprints the
> UUID such that is a 10 digit hex number: 8 digit hex number: 8 digit hex
> number: 6 digit hex number.

Oops, so it does.  Fix below.  Thanks.

>                              It also prints the mdadm device in the
> ARRAY line as /dev/md/# where as mdadm -D --brief prints the device
> as /dev/md#.  Consistency would be nice.

It would be nice .... but how important is it really?
If you create the same array with --name=fred, then
-Eb with give /dev/md/fred, while -Db will give /dev/md2.
Both a right in a sense.

Ofcourse if you say
  mdadm -Db /dev/md/2
then you get /dev/md/2.
You only have /dev/md2 force on you with 
  mdadm -Ds
In that case mdadm doesn't really know what name you want to use for
the md device....  I guess it could scan /dev.

> 
> Does the superblock still not store any information about whether or not
> the array is a single device or partitionable?  Would be nice if the
> superblock gave some clue as to that fact so that it could be used to
> set the auto= param on an mdadm -E --brief line to the right mode.

No the superblock does not store any information about where or not
the array has partitions.  Presumably the partition table does ...

I would recommend that if you want to do everything automatically,
then assemble all arrays as partitionable.  Then you can use it with
or without partitions.


> Mdadm assumes that the --name option passed in to create an array means
> something in particular to the md array name and modifies subsequent
> mdadm -D --brief and mdadm -E --brief outputs to include the name option
> minus the hostname.  Aka, if I set the name to firewall:/boot, mdadm -E
> --brief will then print out the ARRAY line device as /dev/md//boot.  I
> don't think this is documented anywhere.  This also raises the question
> of how partitionable md devices will be handled in regards to their name
> component.

The 'Auto Assembly' section talks about this a bit, though not in the
context of --examine.

The documentation for --auto suggest that in the above case,
partitions would be
   /dev/md/boot1
   /dev/md/boot2

I'm always keen to improve the documentation.  What would you like
included where?

NeilBrown


### Diffstat output
 ./super1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/super1.c ./super1.c
--- .prev/super1.c	2006-10-19 16:45:26.000000000 +1000
+++ ./super1.c	2006-11-09 16:11:57.000000000 +1100
@@ -345,8 +345,8 @@ static void brief_examine_super1(void *s
 	       nm,
 	       c?c:"-unknown-", __le32_to_cpu(sb->raid_disks));
 	for (i=0; i<16; i++) {
-		printf("%02x", sb->set_uuid[i]);
 		if ((i&3)==0 && i != 0) printf(":");
+		printf("%02x", sb->set_uuid[i]);
 	}
 	if (sb->set_name[0])
 		printf(" name=%.32s", sb->set_name);
