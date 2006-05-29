From: Luca Berra <bluca@comedia.it>
Subject: Re: problems with raid=noautodetect
Date: Mon, 29 May 2006 07:02:43 +0200
Message-ID: <20060529050242.GM8203@percy.comedia.it>
References: <4471B188.3060400@umit.at> <17522.15774.526526.244768@cse.unsw.edu.au> <20060526075308.GC8203@percy.comedia.it> <17530.30389.862288.268450@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17530.30389.862288.268450@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 29, 2006 at 02:21:09PM +1000, Neil Brown wrote:
>> 3) introduce "DEVICEFILTER" or similar keyword with the same meaning at
>> the actual "DEVICE" keyboard
>
>If it has the same meaning, why not leave it called 'DEVICE'???

the idea was to warn people that write

DEVICE /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
ARRAY /dev/md0 .......

that it might break since disk naming is not guaranteed to be constant.

>However, there is at least the beginnings of a good idea here.
>
>If we assume there is a list of devices provided by a (possibly
>default) 'DEVICE' line, then 
>
>DEVICEFILTER   !pattern1 !pattern2 pattern3 pattern4
>
>could mean that any device in that list which matches pattern 1 or 2
>is immediately discarded, and remaining device that matches patterns 3
>or 4 are included, and the remainder are discard.
>
>The rule could be that the default is to include any devices that
>don't match a !pattern, unless there is a pattern without a '!', in
>which case the default is to reject non-accepted patterns.
>Is that straight forward enough, or do I need an
>  order allow,deny
>like apache has?
>
I think that documenting the feature would be enough
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
