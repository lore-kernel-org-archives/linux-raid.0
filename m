From: David Greaves <david@dgreaves.com>
Subject: Re: EVMS or md?
Date: Mon, 04 Apr 2005 08:57:50 +0100
Message-ID: <4250F37E.5050201@dgreaves.com>
References: <200504040708.j3478bm03863@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200504040708.j3478bm03863@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Mike Hardy' <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:

>I am top posting since I am starting a new topic.
>  
>
excuses not needed - I prefer it ;)

>Don't get me wrong, I like and trust md, at least with kernel 2.4.
>
>This is the first I knew about EVMS, the website makes it sound wonderfull!
>http://evms.sourceforge.net/
>
>Is EVMS "better" than md?
>  
>
It uses md

A more appropriate question is : Is EVMS "better" than _mdadm_?

Probably - if you're doing more than simple stuff - it doesn't (seem to) offer all the control that mdadm offers but the same gui manages everything from partitioning to bad block management (remember all the raid5 bad block discussions...) to logical volume management and snapshots etc to filesystem creation/expansion/reduction and more including boundary checking (which prevents you from saying "I know what I'm doing" - which is usually a good thing!!!)

So "does it do more than mdadm?" "Yes!"

It's closer (from memory) to Sun's or Veritas' volume management guis

It also introduces a consistent (self-consistent!) set of terminology and a 'way of doing things'.
Eg lvm layers over md layers over bbr layers over partitions

It's also quite intimidating at first sight.

see http://evms.sourceforge.net/architecture/evms-data-example.png

>Is EVMS replacing md?
>  
>
so no - although there are evms md-patches which appear to be in 
mainline now.

>One bad point for EVMS, no RAID6.  :(
>  
>
I think, more correctly: no raid6 config support in the gui...

>One good point for EVMS, bad Block Relocation (but only on writes).
>  
>
again, this uses the dm bbr kernel feature.

>Not sure how EVMS handles read errors.
>
>I am getting on the mailing list(s).  I must know more about this!!!
>
>Guy
>  
>
I don't understand why there is so little cross conversation...
You sometimes need to dip into md stuff to fix/diagnose evms issues.

HTH

David
