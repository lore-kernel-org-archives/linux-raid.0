From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: mismatch_cnt of 128 and 1408.
Date: Tue, 25 Mar 2008 22:07:02 -0400
Message-ID: <200803260207.m2Q278E24843@www.watkins-home.com>
References: <18408.29345.627523.525932@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18408.29345.627523.525932@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>, 'Janek Kozicki' <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Neil Brown
} Sent: Monday, March 24, 2008 11:34 PM
} To: Janek Kozicki
} Cc: linux-raid@vger.kernel.org
} Subject: Re: mismatch_cnt of 128 and 1408.
} 
} On Monday March 24, janek_listy@wp.pl wrote:
} >
} > 5. then after reboot: /usr/share/mdadm/checkarray -a ; cat
} /sys/block/md?/md/mismatch_cnt
} >    md0: 128
} >    md1: 0
} >    md2: 1408
} >
} > Now I am alarmed that something might be wrong with the root
} > partition. From other posts I remember that mismatch count for swap
} > partitions is allowed to be nonzero.
} 
} Yes, the 'swap' is nothing to worry about.

How can a mismatch on swap be ok?  Seems the wrong data could be read in 50%
of the time.

Thanks,
Guy

} 
} As md does it's checks in units of around 128 sectors, the "md0: 128"
} probably just means a single sector is different between the two.
} 
} I recommend
} 
}   echo repair > /sys/block/md0/md/sync_action
} 
} That will fix it.
} 
} Probably just another 'fsck -f' after that just to be on the same
} side.
} 
} NeilBrown
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

