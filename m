From: Dan Pritts <danno@internet2.edu>
Subject: [danno@internet2.edu: minor cosmetic bug in md]
Date: Thu, 15 Feb 2007 13:45:08 -0500
Message-ID: <20070215184508.GC11881@internet2.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(sorry for the direct spam, neil)

----- Forwarded message from Dan Pritts <danno@internet2.edu> -----

Date: Thu, 15 Feb 2007 13:42:36 -0500
From: Dan Pritts <danno@internet2.edu>
To: neilb@suse.de
Subject: minor cosmetic bug in md 

Hi,

I wanted a linear device that included two partitions on the same disk
(I have my reasons).

I created it, it worked, yada yada.

But I got this error in my "dmesg" output:  

  md0: WARNING: hda5 appears to be on the same physical disk as hda7. True
       protection against single-disk failure might be compromised.

Seems silly to give this warning for a linear.   Or, presumably, for a raid0.

thanks for all your good work!

danno
--
Dan Pritts, System Administrator
Internet2
office: +1-734-352-4953 | mobile: +1-734-834-7224

----- End forwarded message -----


danno
--
Dan Pritts, System Administrator
Internet2
office: +1-734-352-4953 | mobile: +1-734-834-7224
