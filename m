From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: mdadm create to existing raid5
Date: Thu, 12 Jul 2007 19:18:28 -0400
Message-ID: <200707122318.l6CNIao08247@www.watkins-home.com>
References: <46969D05.5070700@etelos.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46969D05.5070700@etelos.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Jon Collette' <jon@etelos.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Jon Collette
} Sent: Thursday, July 12, 2007 5:29 PM
} To: linux-raid@vger.kernel.org
} Subject: mdadm create to existing raid5
} 
} I wasn't thinking and did a mdadm --create to my existing raid5 instead
} of --assemble.  The syncing process ran and now its not mountable.  Is
} there anyway to recover from this?
} 
} Thanks
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

Maybe.  Not really sure.  But don't do anything until someone that really
knows answers!

What I think...
If you did a create with the exact same parameters the data should not have
changed.  But you can't mount so you must have used different parameters.

Only 1 disk was written to during the create.  Only that disk was changed.
If you remove the 1 disk and do another create with the original parameters
and put "missing" for the 1 disk your array will be back to normal, but
degraded.  Once you confirm this you can add back the 1 disk.  You must be
able to determine which disk was written to.  I don't know how to do that
unless you have the output from "mdadm -D" during the create/syncing.

But please don't proceed until someone else confirms what I say or gives
better advice!

Guy

