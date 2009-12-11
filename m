From: Luca Berra <bluca@comedia.it>
Subject: Re: Combining OCFS2 with Linux software RAID-0?
Date: Fri, 11 Dec 2009 08:15:26 +0100
Message-ID: <20091211071526.GA4062@maude.comedia.it>
References: <23986fd90912091503r3c671448va4d8637edfab472b@mail.gmail.com> <20091210123703.71b47ce7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091210123703.71b47ce7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 10, 2009 at 12:37:03PM +1100, Neil Brown wrote:
>On Wed, 9 Dec 2009 15:03:11 -0800
>> Has anybody tried something like this?  Are there alternative RAID-0
>> solutions for Linux that would be expected to work?
>
>For RAID0 or LINEAR, this should work - give it a try.
>
_with_ a superblock? or without?
what happens if one node modifies the superblock while the other is
running.

>It might work for RAID1 one day to, but is unlikely to ever work for 
>RAID5.
With an external metadata handler i believe it would be possible to
support up to raid1, maybe 10.

While in similar setups, data protection should be handled by the
storage system, raid 1 has its uses in a failover setup with two sites.
I don't see a real use for raid5/6 in such scenarios.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
