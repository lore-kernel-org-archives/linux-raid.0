From: Gunnlaugur Thor Briem <gthb@hi.is>
Subject: Re: Status of Promise drivers?
Date: Fri, 06 Feb 2004 21:13:53 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40240391.7030209@hi.is>
References: <20031230200012.C14399@nettis.grimsta> <3FF1CCC1.3050304@pobox.com> <20040203192336.A5570@nettis.grimsta> <4021099A.6090209@hi.is>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4021099A.6090209@hi.is>
To: Gunnlaugur Thor Briem <gthb@hi.is>
Cc: Daniel Brahneborg <daniel.com@wtnord.net>, Jeff Garzik <jgarzik@pobox.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Gunnlaugur Thor Briem wrote:
 > http://bugzilla.kernel.org/show_bug.cgi?id=2011
[...]
 > Don't know about any other motherboards, but in any case your kernel is
 > likely to hang when trying to use a PDC 20376 (on a motherboard, as in
 > my case, or on a separate board), for the time being.

... and now he corrects himself. I just tried applying Ross Dickson's 
patches for APIC quirks on nForce2 chipsets:

http://lkml.org/lkml/2003/12/21/7

and that seems to have taken care of my problem completely. I have not 
tested for very long, but I got through the bonnie++ test suite; never even 
came close before.

So the Promise controller and driver appear to be innocent of my woes, and I 
do not know any reason to think that your kernel will hang because of them.

Sorry 'bout that. (And thanks Ross!)

     - Gulli
