From: Ian Thurlbeck <ian@stams.strath.ac.uk>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Fri, 31 Mar 2006 09:08:17 +0100
Message-ID: <442CE371.90900@stams.strath.ac.uk>
References: <Pine.LNX.4.44.0603302227150.18644-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0603302227150.18644-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>>>I have 4x500GB Maxtor SATA drives and I want to attach
>>>these to a 4-port SATA PCI card and RAID5 them using "md"
>>>
>>>Could anybody recommend a card that will have out of
>>>box support on a Fedora system ?
> 
> 
> which FC release?  I believe FC4 would have decent support for 
> promise tx4's (there are at least two - the most recent might
> not work OOB).  sil 3114's ought to work as well.
>

Hi

Currently FC4, but I could update to FC5 on these machines if necessary.
I should add that performance is not really an issue - it's mostly
a read-only data store.  I don't really want to fork out 250 UKPounds
per SATA card (i.e. 3ware 8506) since I don't need
the capabilities (hardware RAID) nor the performance (but I suppose
if I'm forking out 750 UKP for disks what's another 250?)

Mike Hardy recommended the Addonics ADST114 (sil 3114) which has an entry on 
this page:

http://linuxmafia.com/faq/Hardware/sata.html

A little bit outdated though.  (Amazing how many "RAID" cards are "fakeraid")

Thanks for the help!

Ian

> 
>>3ware.  Period.  If you're going to use md, get the 8506-4 series rather 
>>than either of the 9xxx series cards.
> 
> 
> before the 9550, I never found attractive in price/performance: 
> expensive as hell and a lot slower than MD.  but the 9550 is really
> quite impressive...
> 
> regards, mark hahn
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ian Thurlbeck                http://www.stams.strath.ac.uk/
Statistics and Modelling Science, University of Strathclyde
Livingstone Tower, 26 Richmond Street, Glasgow, UK,  G1 1XH
Tel: +44 (0)141 548 3667           Fax: +44 (0)141 552 2079
