From: Luca Berra <bluca@comedia.it>
Subject: Re: mount-by-label finds drive not array ????
Date: Thu, 22 Jul 2004 19:54:24 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040722175424.GF26291@percy.comedia.it>
References: <Pine.LNX.4.58.0407010736180.15444@jupiter.toms.net> <S266708AbUGVQdP/20040722163315Z+2366@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <S266708AbUGVQdP/20040722163315Z+2366@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 22, 2004 at 05:33:13PM +0100, robin-lists@robinbowes.com wrote:
>> 
>> /dev/md0        /mnt/bar      ext3      defaults        0 4
>> 
>> Since if I do it by "LABEL=", it tries to mount hda1, not md0!
>> 
>> Is this just a known/accepted brain-deadness of the mount code?
>
>Tom,
>
>I'm just considering doing something like this.
>
>Did you ever get any resolution to this issue?
is there any need to mount a md device by label, since you can already
identify the md components by uuid when you assemble the raid.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
