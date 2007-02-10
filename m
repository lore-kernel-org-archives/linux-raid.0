From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 2.6.20-rc6] md: expose uuid and degraded attributes in
 sysfs
Date: Sat, 10 Feb 2007 13:09:33 -0500
Message-ID: <45CE0A5D.6040409@tmr.com>
References: <20070127015948.GA24479@teal.hq.k1024.org> <20070210111836.GA7953@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070210111836.GA7953@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: iusty@k1024.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Iustin Pop wrote:
> On Sat, Jan 27, 2007 at 02:59:48AM +0100, Iustin Pop wrote:
>   
>> From: Iustin Pop <iusty@k1024.org>
>>
>> This patch exposes the uuid and the degraded status of an assembled
>> array through sysfs.
>>     
> [...]
>
> Sorry to ask, this was my first patch and I'm not sure what is the
> procedure to get it considered for merging... I was under the impression
> that just sending it to this list is enough. What do I have to do?
Normally I would expect Neil to pick it up and forward it, but I would 
have expected an ack from him. He's been busy with other problems, NFS 
as I recall, and may have missed it, so I cc'd him this time.

Neil, I would think this is 2.6.21 material unless you see a problem I 
missed.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

