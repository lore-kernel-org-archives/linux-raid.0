From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Mdadm server eating drives
Date: Tue, 02 Jul 2013 15:23:42 -0500
Message-ID: <51D336CE.7080800@hardwarefreak.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com> <51BA7B28.9030808@turmel.org> <CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com> <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com> <CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com> <51BB8A67.5000605@turmel.org> <51BB8B86.9050803@turmel.org> <CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com> <alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se> <CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3vQ@mail.gmail.com> <51CC72A4.4040508@jungers.net> <CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gmail.com> <51D233A5.504@hardwarefreak.com> <CAPSPcXjOPben0xGqcUKwyZn4pX
 403uFbp5f57f=LEV371ZuDjw@mail.gmail.com> <51D32DBB.8030401@hardwarefreak.com> <CAKuK5J0LV6s3UMbGJJyX6S8zFh-7FADcpBXGp2vAotTSmKL1WA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKuK5J0LV6s3UMbGJJyX6S8zFh-7FADcpBXGp2vAotTSmKL1WA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Barrett Lewis <barrett.lewis.mitsi@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/2/2013 3:07 PM, Jon Nelson wrote:
> On Tue, Jul 2, 2013 at 2:44 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 7/2/2013 10:48 AM, Barrett Lewis wrote:
>>> After sending the last email I went out and bought 2 new WD reds, and
>>> a new motherboard.  I came back and in those 2 hours all but 1 of my
>>> drives failed to the point of being unable to read the superblock so
>>> it really seems like my array is ended
>>
>> The drive may be ok.  They all may be.
> 
> Indeed. A number of years back, I had an MD RAID array that kept
> throwing drives, one after the other, after years of rock-solid
> stability. Nothing had changed, the machine hadn't been touched (or
> even rebooted!) in months, etc... It turns out that the motherboard
> had gone. It "worked" perfectly, except under any drive load at all it
> would start throwing I/O errors. I replaced only the motherboard (same
> PSU, memory, CPU, etc....) and that machine - built at least 4 years
> ago - is still humming along quite nicely.

Were the drives were attached to the onboard SATA controller or an HBA?

-- 
Stan

