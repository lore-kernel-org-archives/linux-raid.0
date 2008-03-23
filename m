From: Nagy Zoltan <kirk@bteam.hu>
Subject: component growing in raid5
Date: Sun, 23 Mar 2008 07:59:04 +0100
Message-ID: <47E5FFB8.5030903@bteam.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050309050106050303090404"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050309050106050303090404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

hi all,

i've set up a two dimensional array:
    * leaf nodes composes raid5 arrays from their disks, and export it 
as a iSCSI target
    * the root node creates a raid5 on top of the exported targets

in this setup i will have to face that an array component can(and would) 
grow, so i
created a test case for this to see what comes out ;)
    * after growing the components mdadm won't recognized them anymore 
as an array member
        (because there are no superblock at the end of the device - last 
64k?)
       i've tried to inform mdadm about the size of the components, but 
it sad no ;)
    * i've added an arbitary superblock copy operation after the 
expansion, to make possible for
   mdadm to recognize and assemble the array - it's working, and passes 
my test.

is there a less 'funky' solution for this ;)
can i run into any trouble when doing this on the real system?

one more thing: when i first assembled the array with 4096KB chunks, 
i've run into the
'2.6.24-rc6 reproducible raid5 hang' bug, but it won't resume after 
changing
'stripe_cache_size' even after i applied the patch manually to (2.6.24.2)
i've upgraded to 2.6.25-rc6 since then it runs smootly.
- thank you all for hunting that bug down.

kirk


--------------050309050106050303090404
Content-Type: text/plain;
 name="raid-test.bash"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid-test.bash"

#!/bin/bash

t=32768	# size in blocks

xall()
{
	for i in `seq 0 7`;do
		$*
	done
}

mkdir -p part data orig

echo "*** $1"
case "$1" in
	test)
			export		FS_DEV=/dev/md0
			$0 create					&&
			$0 createfs				&&
			$0 stop					&&
			$0 expand					&&
			$0 copy-sb				&&
			$0 lo_up					&&
			$0 assemble				&&
			$0 raid-expand				&&
			$0 fs-expand				&&
			$0 fs-check
			echo "---closing---"
			$0 stop
		;;
	test2)
			export		FS_DEV=/dev/mapper/rt
			$0 create					&&
			$0 crypt /dev/md0			&&
			$0 crypt-open				&&
			$0 createfs				&&
			$0 crypt-close				&&
			$0 stop					&&
			$0 expand					&&
			$0 copy-sb				&&
			$0 lo_up					&&
			$0 assemble				&&
			$0 raid-expand				&&
			$0 crypt-open				&&
			$0 fs-expand				&&
			$0 fs-check
			echo "---closing---"
			$0 stop
		;;
	zero)
			q(){	
				rm -f part/$i;	touch part/$i;	}
			xall q
		;;
	expand)
			cp part/{0..7} orig/
			q(){	
				dd if=/dev/zero count=$t >> part/$i;		}
			xall q
		;;
	raid-expand)
			i=0
			s=`stat --printf '%s' part/$i`;
			x=$[ ($s / 1024)-64 ]
			mdadm --grow -z $x /dev/md0
			
		;;
	create)
			$0 zero
			$0 expand
			$0 lo_up
			mdadm -Cv -n8 -l5 /dev/md0 /dev/loop{0..7}
		;;
	crypt)
			dd if=/dev/urandom count=1 of=key
			cryptsetup luksFormat /dev/md0 key				||	exit 1
		;;
	crypt-open)
			cryptsetup luksOpen /dev/md0 rt --key-file key	||	exit1
		;;
	crypt-close)
			cryptsetup luksClose rt						||	exit 1
		;;
	fs-expand)
			[ "$FS_DEV" == "" ] && echo "!!! FS_DEV not set" && exit 1
			mount $FS_DEV data
			xfs_growfs data
			umount data
		;;
	fs-check)
			[ "$FS_DEV" == "" ] && echo "!!! FS_DEV not set" && exit 1
			mount $FS_DEV data
			md5sum -c hash && echo ok || echo error
			umount data
		;;
	createfs)
			[ "$FS_DEV" == "" ] && echo "!!! FS_DEV not set" && exit 1
			mkfs.xfs $FS_DEV
			mount $FS_DEV data
			dd if=/dev/urandom of=data/junk
			md5sum data/junk | tee hash
			umount data
		;;
	lo_up)
			q(){
				losetup /dev/loop$i part/$i;	}
			xall q
		;;
	lo_down)
			q(){
				losetup -d /dev/loop$i;	}
			xall q
		;;
	assemble)
			mdadm -Av /dev/md0 /dev/loop{0..7}
		;;
	stop)
			umount data
			$0 crypt-close
			mdadm -S /dev/md0
			$0 lo_down
		;;
	copy-sb)
			q(){
				s=`stat --printf '%s' part/$i`;
				tail -c 65536 orig/$i | dd bs=1 seek=$[ $s - 65536 ] of=part/$i;	}
			xall q
		;;
	*)	echo "asd"
		;;
esac

--------------050309050106050303090404--
