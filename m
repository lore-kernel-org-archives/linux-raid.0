From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 23:58:17 +1100
Message-ID: <5113A4E9.5020005@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5113A3D4.6000605@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/13 23:53, Phil Turmel wrote:
> On 02/07/2013 07:49 AM, Adam Goryachev wrote:
>> Well, if I can re-trim daily, and have enough clean space to work for 2
>> days, then I should never hit this problem.... Assuming it loses *that
>> much* performance....
> 
> You keep saying this, but you are only going to be trimming the
> unpartitioned space.  That won't help you after the first trim.


Right, so if I TRIM it each night, then the next day, there is a bunch
of freshly TRIM'ed space to use up. As long as there is enough for the
day's writes, then I won't face this issue of slow writes while the SSD
is trying to do garbage collection or whatever...

Or, I'm just dreaming :)

Or, this isn't my problem, so I should just ignore it....

Thanks,
Adam


-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
