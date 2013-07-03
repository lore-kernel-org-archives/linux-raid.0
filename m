From: Phil Turmel <philip@turmel.org>
Subject: Re: Mdadm server eating drives
Date: Wed, 03 Jul 2013 10:36:32 -0400
Message-ID: <51D436F0.7050503@turmel.org>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com> <CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com> <51BB8A67.5000605@turmel.org> <51BB8B86.9050803@turmel.org> <CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com> <alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se> <CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3vQ@mail.gmail.com> <51CC72A4.4040508@jungers.net> <CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gmail.com> <51D233A5.504@hardwarefreak.com> <CAPSPcXjOPben0xGqcUKwyZn4pX403uFbp5f57f=LEV371ZuDjw@mail.gmail.com> <51D32DBB.8030401@hardwarefreak.com> <CAPSPcXg_fy-YYfwa1w4=3ZzA3sb71V+Kvai7qHAXNfiS3WAXGQ@mail.gmail.com> <51D38354.6090001@har
 dwarefreak.com> <CAPSPcXjn4=mxMLtu=88Fm9kFvh6_ujLwrTvQeqQuef3BG_c26Q@mail.gmail.com> <CAKuK5J0nYf3j_zTLCjBOKw49ADTKqJwU+fa7pVo4incW8J9RBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKuK5J0nYf3j_zTLCjBOKw49ADTKqJwU+fa7pVo4incW8J9RBQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Barrett Lewis <barrett.lewis.mitsi@gmail.com>, Stan Hoeppner <stan@hardwarefreak.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/03/2013 10:03 AM, Jon Nelson wrote:
> On Wed, Jul 3, 2013 at 12:26 AM, Barrett Lewis
> <barrett.lewis.mitsi@gmail.com> wrote:
>>
>> didn't sound like a single source at all.  But I guess could have been
>> mistaken.  I have been really curious about this "beeping" issue since
>> it is so bizarre.  Anyway like I said only 2 of those original 6 (they
>> were seagate ST2000DM001) remain.
> 
> 
> A quick google search shows the ST2000DM001 (which I have 2 of) *do*
> make "chirping" or "beeping" noises. Additionally, it seems there are
> firmware updates available. Sadly, I bought two of these drives some
> months ago (current firmware: CC26) and so far so good. However,
> should I be worried about these drives?

They don't support ERC.  You *must* use a 2-3 minute driver timeout for
these if you use them in a raid array.

Phil
