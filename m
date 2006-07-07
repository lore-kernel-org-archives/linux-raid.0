From: Luca Berra <bluca@comedia.it>
Subject: Re: issue with internal bitmaps
Date: Fri, 7 Jul 2006 10:29:39 +0200
Message-ID: <20060707082939.GC18956@percy.comedia.it>
References: <20060706141207.GC21642@percy.comedia.it> <17581.35762.452409.927246@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17581.35762.452409.927246@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 07, 2006 at 08:16:18AM +1000, Neil Brown wrote:
>On Thursday July 6, bluca@comedia.it wrote:
>> hello, i just realized that internal bitmaps do not seem to work
>> anymore.
>
>I cannot imagine why.  Nothing you have listed show anything wrong
>with md...
>
>Maybe you were expecting
>   mdadm -X /dev/md100
>to do something useful.  Like -E, -X must be applied to a component
>device.  Try
>   mdadm -X /dev/sda1
>
/me needs some strong coffe. yes you are right, sorry

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
