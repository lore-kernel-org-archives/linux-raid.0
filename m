From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Can you IMAGE Mirrored OS Drives?
Date: Tue, 15 Aug 2006 22:24:30 -0400
Message-ID: <200608160224.k7G2OaL20341@www.watkins-home.com>
References: <44E250CD.5040308@aol.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44E250CD.5040308@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'andy liebman' <andyliebman@aol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} 
} -- I know there was a lot of discussion on the list a while back about
} whether or not to mirror SWAP space. Was there ever any conclusion? It
} seems to me that mirroring will ensure that if one drive fails, you
} don't lose information in virtual memory. My applications rarely if
} every use virtual memory anyway so I'm not worried about speed. I want
} the ultimate in stabilty for the OS drive. Otherwise, I guess I would
} designate swap space on just one drive (but prepare identical partitions
} on each for swap). If the first drive failed (/dev/sda -- with the swap
} space), /dev/sdb would become the new /dev/sda anyway. And so fstab
} would be correct in pointing to /dev/sda.

You should mirror swap space!  Otherwise you will have an outage if a disk
fails.  Most places would not accept an outage for a simple disk failure.
IMO.

Guy

} 
} Sound opinions welcome.
} 
} Thanks,
} Andy Liebman
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

