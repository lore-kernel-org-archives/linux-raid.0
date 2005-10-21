From: Gil <gil@fooplanet.com>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Fri, 21 Oct 2005 09:48:04 -0700
Message-ID: <43591BC4.7090903@fooplanet.com>
References: <dhje16$tmq$1@sea.gmane.org> <433F63BB.3020008@nighthawkrad.net> <7f55de720510030933k26608cfsda63326a8438e35d@mail.gmail.com> <43420091.9060601@nighthawkrad.net> <43577022.5010306@robinbowes.com> <20051020111943.GA9757@anthropohedron.net> <435871A4.8040304@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <435871A4.8040304@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: gsslist+linuxraid@anthropohedron.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christopher Smith wrote:
> Gregory Seidman wrote:
> 
>> You should at least read the following before using RAID5. You 
>> can agree or disagree, but you should take the arguments into 
>> account:
>> 
>> http://www.miracleas.com/BAARF/RAID5_versus_RAID10.txt

> For example, his article suggests that "partial media failure" is
> a problem that would only affect RAID5, when really it would 
> negatively impact any RAID system (your newly-synced mirror isn't
> much good if half the data that just got mirrored to it was 
> corrupted, nor is the speed boost from RAID0 very helpful if half
> the data is corrupted).  I'm also not sure about his claims of 
> RAID3 & 4 "always" checking parity - that sounds like a 
> vendor-specific implementation (and while I'm not a developer, I 
> fail to see why a RAID5 implementation couldn't be made to do the
> same).

The partial media failure problem described here is exactly why it's
important to run smartmontools in combination with your RAID array
of any level.  By running regular checks of the disk surface you can
know well ahead of time that you're going to have trouble.  in
practice this more than mitigates the risk of partial media failure.

http://smartmontools.sourceforge.net/

--Gil
