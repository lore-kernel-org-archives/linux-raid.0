From: Luca Berra <bluca@comedia.it>
Subject: Re: problems with raid=noautodetect
Date: Tue, 30 May 2006 19:30:20 +0200
Message-ID: <20060530173020.GD4022@percy.comedia.it>
References: <4471B188.3060400@umit.at> <17522.15774.526526.244768@cse.unsw.edu.au> <20060526075308.GC8203@percy.comedia.it> <17530.30389.862288.268450@cse.unsw.edu.au> <447C7C80.3080002@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <447C7C80.3080002@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 30, 2006 at 01:10:24PM -0400, Bill Davidsen wrote:
>>>2) deprecate the "DEVICE" keyword issuing a warning when it is found in
>>>the configuration file
>>
>>Not sure I'm so keen on that, at least not in the near term.
>>
>Let's not start warning and depreciating powerful features because they 
>can be misused... If I wanted someone to make decisions for me I would 
>be using this software at all.

you cut the rest of the mail.
i did not propose to deprecate the feature,
just the keyword.

but, ok,
just go on writing 
DEVICE /dev/sda1
DEVICE /dev/sdb1
ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1

then come on the list and complain when it stops working.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
