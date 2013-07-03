From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Mdadm server eating drives
Date: Wed, 03 Jul 2013 12:32:00 -0500
Message-ID: <51D46010.6040109@hardwarefreak.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com> <CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com> <51BB8A67.5000605@turmel.org> <51BB8B86.9050803@turmel.org> <CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com> <alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se> <CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3vQ@mail.gmail.com> <51CC72A4.4040508@jungers.net> <CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gmail.com> <51D233A5.504@hardwarefreak.com> <CAPSPcXjOPben0xGqcUKwyZn4pX403uFbp5f57f=LEV371ZuDjw@mail.gmail.com> <51D32DBB.8030401@hardwarefreak.com> <CAPSPcXg_fy-YYfwa1w4=3ZzA3sb71V+Kvai7qHAXNfiS3WAXGQ@mail.gmail.com> <51D38354.6090001@har
 dwarefreak.com> <CAPSPcXjn4=mxMLtu=88Fm9kFvh6_ujLwrTvQeqQuef3BG_c26Q@mail.gmail.com> <CAKuK5J0nYf3j_zTLCjBOKw49ADTKqJwU+fa7pVo4incW8J9RBQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKuK5J0nYf3j_zTLCjBOKw49ADTKqJwU+fa7pVo4incW8J9RBQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Barrett Lewis <barrett.lewis.mitsi@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/3/2013 9:03 AM, Jon Nelson wrote:

> A quick google search shows the ST2000DM001 (which I have 2 of) *do*
> make "chirping" or "beeping" noises. Additionally

Yes, Seagate still makes some relatively noisy drives compared to others
on the market.  I had ST225s and ST251s in the late 80s that could be
heard across a large room.  All drives were noisy back then due to the
use of stepper motors.  Drives have used voice coil actuators since the
early 90s, shortly after the IDE spec was adopted, which are an order of
magnitude quieter.  These are very old and thus a bit noiser, but not
all that much:

http://www.youtube.com/watch?v=NYEkC7FBXa4
http://www.youtube.com/watch?v=RZMrwdQBVf4

But surely nobody would confuse this random mechanical drive noise for
an audible alarm.  And of course, with dirty power as in the OP's case,
drives will make more noise due to the firmware doing constant
recalibration of the heads as the spindle constantly drops below minimum
RPM threshold and comes back up again when voltage increases.

I think some people have simply become accustomed to ultra quiet drives
that rarely make a peep, and when they do people get all nervous.

-- 
Stan

