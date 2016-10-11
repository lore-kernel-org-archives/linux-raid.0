From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RAID6 - CPU At 100% Usage After Reassembly
Date: Tue, 11 Oct 2016 20:46:14 +0800
Message-ID: <df339a8a-1f44-0d0f-41b3-a308a9c270ed@fnarfbargle.com>
References: <CADEsfxrKeSv5dRNfBoyybHaemPSqCcamTmSZ4P+Yey-rLd8hEg@mail.gmail.com>
 <CAOW94uv4zSGs+6be3zhcQaGZdiAgg-s4ZHZ=mszcURo6pqJyqA@mail.gmail.com>
 <CAOW94ute6CZafnAC6AVauqUGsEgVrnO3B27Gn3eVzdWFBJPCQw@mail.gmail.com>
 <CAOW94utnY1zCR7gUCx1K0p2YfDhi3tXTsE6J_mT6rNz1TuTZEQ@mail.gmail.com>
 <20160913174352.GA43576@kernel.org>
 <CAOW94us2=5F8BbLhQSN_mC0wghZA8Z6qFQHBP5Y1csJuQ4pfKg@mail.gmail.com>
 <CAOW94utVBcLz191ifzKkjn+nsSthPWDAQF8R-PabcS2uPareag@mail.gmail.com>
 <CAOW94usC2AFt4uGRZRidcXN1Gii0PqSqfGAjL6_2Y1m6GAcZsg@mail.gmail.com>
 <CAOW94uvFaiL9FO=k=gOsGzH0q1Qhw4X3n7ZFURj9_eTgGa656g@mail.gmail.com>
 <CAOW94uuALbxOpfb5Rgzp=Fgvy8zfKt94zCcgs7T=U-m8jWGq3g@mail.gmail.com>
 <20161006235530.GA109312@kernel.org>
 <CAOW94uvxPH9dhpd=-t+eMfOc3YPLxasViz29idZmbQn-GkP5vg@mail.gmail.com>
 <63380999-4291-97e9-41e4-363903e5c07b@fnarfbargle.com>
 <57FCAF93.9040305@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57FCAF93.9040305@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Francisco Parada <advanceandconquer@gmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/16 17:23, Wols Lists wrote:

> It strikes me this would be a good addition too - I could probably
> manage something of the sort, but do you or anyone have the code to
> detect a green, and do that "disable parking and spindown"? It's a pain,
> but having a script that deals with all known and common issues with
> drives is probably a good thing.
>

The command to disable head parking is a vendor specific command, is 
non-volatile and requires a drive power cycle. So it's a one off set and 
forget when you get the drive.

Excerpt from hdparm man page :
        -J     Get/set the Western Digital (WD) Green Drive's "idle3" 
timeout value.  This timeout controls how often the drive parks its 
heads and enters a low power consumption state.  The factory default is 
eight (8) seconds, which is a very poor choice for use with Linux. 
Leaving it at the  default  will
               result in hundreds of thousands of head load/unload 
cycles in a very short period of time.  The drive mechanism is only 
rated for 300,000 to 1,000,000 cycles, so leaving it at the default 
could result in premature failure, not to mention the performance impact 
of the drive often having to wake-
               up before doing routine I/O.

I just set them to J 0. This applies to the WD Red drives also.

I forget how to tackle the spindown command. I think I used hdparm -S 
every boot, same as the setting scterc timeout.

None of the machines I use with RAID arrays are idle long enough to spin 
down the disks.


