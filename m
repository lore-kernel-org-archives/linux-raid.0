From: Luca Berra <bluca@comedia.it>
Subject: Re: what superblock to use
Date: Mon, 20 Apr 2009 23:24:54 +0200
Message-ID: <20090420212454.GC5550@maude.comedia.it>
References: <20090420141702.GC17461@maude.comedia.it> <20090420193914009.EBTN9976@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090420193914009.EBTN9976@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 20, 2009 at 02:39:05PM -0500, Leslie Rhorer wrote:
>
>> >what's the current recommended superblock to use for a newly created
>> >raid5-6 array with 6 pieces of 1tb disk? by default mdamd use 0.90. is
>> >it worth to change it to any 1.x format?
>> 0.9 has some limitations that 1.x do not have, none apply in your case
>> max_components = 28
>> max_size of component=2TB
>
>Oops!  I did not realize this when I built my array.  I'm going to need to
>grow the array to 3T components after the 3T drives are released.  Can the
>superblock be changed on an existing array, or does it have to be rebuilt
>from scratch?  If the latter, I'm glad I learned this now, because I may
>have to rebuild the array, anyway, to try to alleviate the halt issue I am
>experiencing.

afaik it cannot be changed after creation
if you have free space you could play tricks reducing the fs, recreating
the array with the exact same parameters except metadata and
--assume-clean (you are limited to using 1.0 in this case)
anyway do a backup before trying this.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
