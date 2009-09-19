From: "Guy Watkins" <guy@watkins-home.com>
Subject: RE: RAID 5 array recovery - two drives errors in external enclosure
Date: Fri, 18 Sep 2009 21:35:33 -0400
Message-ID: <AFD5FB84146A49B186DAB822C95DE16D@m5>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com> <20090918080706.GB22909@cthulhu.home.robinhill.me.uk> <2267211f0909180827jbfa57acqadd308b4b889058c@mail.gmail.com> <6b696870909180910q67d8166ay7796321b8cd35809@mail.gmail.com> <2267211f0909180912p745e4ea0idb5659cb54a6adce@mail.gmail.com> <6b696870909180923m35f29fa2l857b6f6402eb20be@mail.gmail.com> <2267211f0909181041o29d6f5eft1e260696c6ab9c57@mail.gmail.com> <6b696870909181317x777e3c5dsdcf0e7709f9c4979@mail.gmail.com> <2267211f0909181630r33fcdbe5hb0d158b9bf12924b@mail.gmail.com> <70ed7c3e0909181637g35b31926ref7e4a16beaab73c@mail.gmail.com> <1f0f1a960909181817s6ad0a3f3l386a478603e9fde8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f0f1a960909181817s6ad0a3f3l386a478603e9fde8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Tom Carlson' <twigathy@gmail.com>, "'Majed B.'" <majedb@gmail.com>
Cc: 'Tim Bostrom' <tbostrom@gmail.com>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If you are starting over, maybe you should use RAID6?

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Tom Carlson
} Sent: Friday, September 18, 2009 9:18 PM
} To: Majed B.
} Cc: Tim Bostrom; linux-raid
} Subject: Re: RAID 5 array recovery - two drives errors in external
} enclosure
} 
} 2009/9/19 Majed B. <majedb@gmail.com>:
} > If you're going to take all your data out, I would suggest you do a
} > clean start and zero out all the disks to force the remapping of bad
} > sectors, then run smartctl -t offline on all disks and after it's done
} > (it will take A LONG time), create your filesystem on an array and put
} > back your data.
} 
} I'd recommend running the badblocks program on each device to be put
} in the array too, just to be certain that none of your disks are going
} to go horribly flakey on assembly and build... I'm not sure if the
} offline smart test does a full scan like badblocks would.
} 
} T
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

