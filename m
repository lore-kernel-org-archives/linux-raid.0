From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: 2 Hard Drives & RAID
Date: Sat, 9 Sep 2006 21:17:03 -0400
Message-ID: <200609100117.k8A1H9D22553@www.watkins-home.com>
References: <45031F68.4020403@panix.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45031F68.4020403@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'berk walker' <berk@panix.com>, 'Justin Piszcz' <jpiszcz@lucidpixels.com>
Cc: "'Sandra L. McGrew'" <momo_1@alltel.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of berk walker
} Sent: Saturday, September 09, 2006 4:09 PM
} To: Justin Piszcz
} Cc: Sandra L. McGrew; linux-raid@vger.kernel.org
} Subject: Re: 2 Hard Drives & RAID
} 
} Justin Piszcz wrote:
} 
} >
} >
} > On Wed, 6 Sep 2006, Sandra L. McGrew wrote:
} >
} >> I have two hard drives installed in this DELL GX110 Optiplex computer.
} I
} >> believe that they are configured in RAID5, but am not certain. Is
} >> there a
} >> graphical method of determining how many drives are being used and
} >> how they
} >> are configured???
} >> I'm using Debian, 'Sarge'...
} >>
} >> The computer is incrediby fast... I'm thinking that could be because
} >> it's a
} >> DELL or because the drives are mirrored...
} >>             I would apppreciate any help that you can give me...
} >>                   Most sincerley,
} >>                                Dan
} (nurse1@longviewcomm[removethis].net)
} >>
} >> -
} >> To unsubscribe from this list: send the line "unsubscribe linux-raid"
} in
} >> the body of a message to majordomo@vger.kernel.org
} >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
} >>
} >
} > RAID5 requires 3 drives or more.
} >
} > To check your disks type: fdisk -l as root.
} >
} > Justin.
} >
} >
} Actually, RAID5 requires 2 drives, but that does defeat most of the
} reason for RAID5 in the 1st place.

RAID5 only requires 1 drive, if one is missing!  :)

} 
} I think that "cat /proc/mdstat" is a fast way to see if the box sees the
} drives as RAID.  If you have mdadm installed, it has a wealth of querys
} - assuming that you do have some RAID items - and they may be whole
} disks or partitions.
} 
} b-
} 
} 
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

