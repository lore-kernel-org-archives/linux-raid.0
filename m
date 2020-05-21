From: antlists <antlists@youngman.org.uk>
Subject: Re: re-add syntax
Date: Fri, 22 May 2020 00:17:43 +0100
Message-ID: <48fe44c5-f43e-3167-fd08-077dfc429cf2@youngman.org.uk>
References: <20200520235347.GF1415@justpickone.org>
 <5EC63745.1080602@youngman.org.uk> <20200521110139.GW1711@justpickone.org>
 <20200521112421.GK1415@justpickone.org> <5EC66D4E.8070708@youngman.org.uk>
 <20200521123306.GO1415@justpickone.org>
 <828a3b59-f79c-a205-3e1e-83e34ae93eac@youngman.org.uk>
 <20200521131500.GP1415@justpickone.org>
 <20200521180700.GT1415@justpickone.org>
 <CAAMCDecB+CU-EGtx+4bMPKBYcy65sgT-8MW=s=OeviyZeq6URA@mail.gmail.com>
 <20200521225230.GU1415@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200521225230.GU1415@justpickone.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: David T-G <davidtg-robot@justpickone.org>, Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/05/2020 23:52, David T-G wrote:
> Roger, et al --
> 
> ...and then Roger Heflin said...
> %
> % For re-add to work the array must have a bitmap, so that mdadm knows
> % what parts of the disk need updating.
> [snip]
> 
> Ahhhhh...  Thanks!
> 
> I've wondered about an internal bitmap vs not.  I also wonder how big the
> bitmap is and where else I might stick it ...
> 
Bear in mind the bitmap is obsolete ... I need to get my head round it, 
but you should upgrade from bitmap to journal ... amongst other things, 
this fixes the "raid 5 write hole" - not sure what it is but it seems 
inherent in the design of raid 5 that if something goes wrong it is easy 
to lose data. Journalling presumably fixes that the same way it fixes 
write losses in general ...

(Oh - and if you somehow manage to switch on bitmaps and journals 
together the resulting array will refuse to assemble. The current tools 
won't let you have both, but older versions can.)

Cheers,
Wol
