From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH] mdadm: monitor event argument passing
Date: Mon, 03 Apr 2006 15:55:20 -0400
Message-ID: <44317DA8.9040500@steeleye.com>
References: <442D7864.9020901@steeleye.com> <17456.26958.388668.339215@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17456.26958.388668.339215@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday March 31, paul.clements@steeleye.com wrote:
> 
>>I've been looking at the mdadm monitor, and thought it might be useful 
>>if it allowed extra context information (in the form of command line 
>>arguments) to be sent to the event program, so instead of just:
>>
>># mdadm -F /dev/md0 -p "md_event"
>>
>>you could do something like:
>>
>># mdadm -F /dev/md0 -p "md_event -i <some_info>"
>>
>>And the "-i <some_info>" will be passed on the command line to the event 
>>program. Of course you can usually figure out what the extra context 
>>should be in the event program itself, but it may take more work.
> 
> 
> I would recommend the use of environment variables for this:
> 
>   md_event_context=<some_info> mdadm -F /dev/md0 -p md_event

> Does that work for you?

Yes, that would work.

Thanks,
Paul
