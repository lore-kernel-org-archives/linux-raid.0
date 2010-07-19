From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: messed up changing chunk size
Date: Sun, 18 Jul 2010 21:29:20 -0400
Message-ID: <D891326971E54910A757A5BBB9EEDD74@m5>
References: <4C439D19.4070906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4C439D19.4070906@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Konstantin Svist' <fry.kun@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think this should work:
Put the chunk size back, resize the array to the original size, then run
fsck and hope it did not need the data on the end that got trashed.  Then
shrink your file system first (by a really safe margin), then resize the
array, then change chunk size.  Then grow the file system to use the max
allowed.

Maybe the data on the end did not get trashed, but I don't know.


} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Konstantin Svist
} Sent: Sunday, July 18, 2010 8:32 PM
} To: linux-raid@vger.kernel.org
} Subject: messed up changing chunk size
} 
}   I've been playing around with RAID config and may have finally messed
} it up.
} 
} Initially, I created the array with 3 300G drives:
} # mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sda4
} /dev/sdb1 /dev/sdc1
} # mkfs.ext4 -v -m 0.01 -E stride=16,stripe-width=32 /dev/md0
} 
} It's been working nicely so far, and I decided to add a 4th 300G drive:
} # mdadm --grow --raid-devices=4 --backup-file=/root/grow_md0.bak /dev/md0
} 
} That finished overnight, while I looked around and found that chunk size
} of 512 should work better. I unmounted the FS and ran
} # mdadm --grow -c 512 --backup-file=/root/grow_md0_rechunk.bak /dev/md0
} mdadm: component size 293033536K is not a multiple of chunksize 512K
} 
} so I sized it down a bit:
} # mdadm --grow -z 293033472 --backup-file=/root/grow_md0_size.bak /dev/md0
} 
} and then back to resizing chunks:
} mdadm --grow -c 512 --backup-file=/root/grow_md0_rechunk.bak /dev/md0
} 
} It's running right now:
} # cat /proc/mdstat
} Personalities : [raid6] [raid5] [raid4]
} md0 : active raid5 sdd1[3] sda4[0] sdc1[2] sdb1[1]
}        293033472 blocks super 0.91 level 5, 64k chunk, algorithm 2 [4/4]
} [UUUU]
}        [====>................]  reshape = 22.7% (66540032/293033472)
} finish=947.3min speed=3984K/sec
} 
} 
} But just now I tried to mount the filesystem and it's failing:
} EXT4-fs (md0): bad geometry: block count 146516768 exceeds size of
} device (73258368 blocks)
} 
} Here's the question, then: am I royally screwed or is my data still
} there? How do I recover?
} 
} 
} 
} Yes, in retrospect I should've probably checked around whether this
} process has been successful for others.. but that's why they say
} hindsight is 20/20
} 
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

