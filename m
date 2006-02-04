From: Luca Berra <bluca@comedia.it>
Subject: Re: ANNOUNCE: mdadm 2.3 - A tool for managing Soft RAID under Linux
Date: Sat, 4 Feb 2006 20:54:19 +0100
Message-ID: <20060204195418.GC32334@percy.comedia.it>
References: <17377.38441.974634.267086@cse.unsw.edu.au> <20060204173744.GB31715@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060204173744.GB31715@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 04, 2006 at 06:37:45PM +0100, Luca Berra wrote:
>On Thu, Feb 02, 2006 at 04:18:33PM +1100, Neil Brown wrote:
>>
>>
>>I am pleased to announce the availability of
>>   mdadm version 2.3
>>
>and i am pleased to reply with the first patch for mdadm 2.3,
>which will allow building on 64bit machines.
>
A more knowledgeable C programmer than me suggested using PRIu64
instead of casting to format correctly theese printfs, what do you
think about it?


Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
