From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Fri, 08 Feb 2013 18:17:42 +1100
Message-ID: <5114A696.4030908@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <511471EA.2000605@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511471EA.2000605@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/02/13 14:32, Stan Hoeppner wrote:

> 6.  And number of kernel tuning issues on the W2K DC guest causing
>     network and/or iSCSI IO issues, memory allocation problems, pagefile
>     problems, etc.

I forgot to mention something else under consideration here... I recall
an older windows 2003 VM which was running service pack 2 being very
slow under xen, and the solution was to upgrade to service pack 4 (from
the xen mailing list, advised there was something windows did to make
xen very in-efficient pre sp4). I don't recall if this applied to
win2000, but I will probably upgrade the win2k DC to windows 2003
service pack 4 over the coming weekend (depending on approval/etc).
AFAIK, this should be a fairly painless upgrade, and is definitely
something I want to get done anyway.

I'd still like to focus on running some tests to ensure the system is
working properly, and/or find the issues in the other parts and resolve them

Thank you to everyone who has offered any suggestions or advice so far.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
