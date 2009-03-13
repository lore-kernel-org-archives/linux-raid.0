From: Alain Williams <addw@phcomp.co.uk>
Subject: Re: High IO Wait with RAID 1
Date: Fri, 13 Mar 2009 10:17:07 +0000
Message-ID: <20090313101707.GF29989@mint.phcomp.co.uk>
References: <7d86ddb90903121646q485ad12y90824a4c3fcc2dfd@mail.gmail.com> <20090313004802.GB29989@mint.phcomp.co.uk> <7d86ddb90903122021y5f4f0868na3f1944f87f77f4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7d86ddb90903122021y5f4f0868na3f1944f87f77f4a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 12, 2009 at 10:21:28PM -0500, Ryan Wagoner wrote:
> I'm glad I'm not the only one experiencing the issue. Luckily the
> issues on both my systems aren't as bad. I don't have any errors
> showing in /var/log/messages on either system. I've been trying to
> track down this issue for about a year now. I just recently my the
> connection with RAID 1 and mdadm when copying data on the second
> system.

Did you have the problem straight from install, or perhaps when a new
kernel started being used ?

My system worked well for some months, there was no kernel update and
it started to go wrong a couple of weeks ago. I also see errors
when I run 'badblocks' -- which makes it smell of a hardware issue,
but the disks were tested, on return, by the hardware supplier and
they did not find any problem with them.

Given that you are not seeing anything in /var/log/messages make me
think that I do have some other problem -- perhaps in addition to
what you have.

-- 
Alain Williams
Linux/GNU Consultant - Mail systems, Web sites, Networking, Programmer, IT Lecturer.
+44 (0) 787 668 0256  http://www.phcomp.co.uk/
Parliament Hill Computers Ltd. Registration Information: http://www.phcomp.co.uk/contact.php
Past chairman of UKUUG: http://www.ukuug.org/
#include <std_disclaimer.h>
