From: Luca Berra <bluca@comedia.it>
Subject: Re: stacked raid devices not autodetected?
Date: Mon, 6 Dec 2004 12:49:24 +0100
Message-ID: <20041206114923.GF4693@percy.comedia.it>
References: <912C966151E990A5186A8A78@pcmy.sei.cmu.edu> <51419.164.129.1.39.1102088099.squirrel@164.129.1.39> <20041206113752.GM3858@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20041206113752.GM3858@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Dec 06, 2004 at 12:37:52PM +0100, Lars Marowsky-Bree wrote:
>On 2004-12-03T16:34:59, Luca Berra <bluca@comedia.it> wrote:
>
>> > On boot, the kernel automatically detects and starts md0 through md4.
>> > However, md5 is *not* autodetected.  Using the RAID_AUTORUN ioctl also
>> > has no effect.  The only way I've found to reliably start md5 is to
>> > have rc.sysinit run "mdadm -assemble --scan".
>> >
>> > Is this a bug?  A design limitation?  Something else?
>> this is one of the limitations of the in-kernel autodetection
>
>You can pull a fix for that one out of the SUSE kernel, where we add md
>devices we just started to the auto detection. It worked pretty well in
>2.4, but my memory is hazed when I try to recall whether it was all
>ported to 2.6...
>
is it worth doing that in-kernel, i really believe that identifying
and starting arrays is a job that is better done in user-space.

regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
