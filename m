From: David Liontooth <liontooth@cogweb.net>
Subject: Re: RAID 16?
Date: Thu, 02 Feb 2006 16:59:20 -0800
Message-ID: <43E2AAE8.7000507@cogweb.net>
References: <200602030020.k130KGq13372@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200602030020.k130KGq13372@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Mario 'BitKoenig' Holbe' <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I appreciate all the expert feedback on this.  We'll be able to make a
well-informed decision on how to proceed.

Best,
Dave

Guy wrote:

>He can loose 1 disk from any 2 RAID1 arrays.  And then 2 disks from the
>other 2 RAID1 arrays.  A total of 6 of 8 disks can fail if chosen correctly.
>
>I would go with an 8 disk RAID6, which would give the space of 6 disks and
>support any 2 disks failing.  Or a 7 disk RAID6 with 1 spare, but I think
>that is over kill.
>
>Guy
>
>} -----Original Message-----
>} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>} owner@vger.kernel.org] On Behalf Of Mario 'BitKoenig' Holbe
>} Sent: Thursday, February 02, 2006 1:42 PM
>} To: linux-raid@vger.kernel.org
>} Subject: Re: RAID 16?
>} 
>} Matthias Urlichs <smurf@smurf.noris.de> wrote:
>} > Hi, David Liontooth wrote:
>} >>   * define 4 pairs of RAID 1 with an 8-port 3ware 9500S card * the OS
>} will
>} > Hmm. You'd have eight disks, five(!) may fail at any time, giving you
>} 
>} Four, isn't it?
>} RAID6 covers the failure of 2 of the underlying RAID1s, which, in turn,
>} means failures of 2 disks each, so four.
>} Sometimes even 5, yes - given the right ones fail.
>} 
>} 
>} regards
>}    Mario
>} --
>} We are the Bore. Resistance is futile. You will be bored.
>} 
>} -
>} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>} the body of a message to majordomo@vger.kernel.org
>} More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

