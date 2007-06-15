From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid1 with nbd member hangs MD on SLES10 and RHEL5
Date: Fri, 15 Jun 2007 09:21:01 -0400
Message-ID: <4672923D.7070900@tmr.com>
References: <170fa0d20706121930g3b89ddeex8b31c8923d2a0ff6@mail.gmail.com>	 <18031.22930.243723.550238@notabene.brown>	 <170fa0d20706121959w480213bcvaba1b6881710379f@mail.gmail.com>	 <170fa0d20706122009h5e3db54ek7487be4940a3d780@mail.gmail.com>	 <18031.25581.353761.802283@notabene.brown>	 <170fa0d20706122130q2c77d365tbe9261bab1a5b1b@mail.gmail.com>	 <170fa0d20706131123q17e4fb9ehe6be25a07462cc30@mail.gmail.com> <170fa0d20706131630p6cd29aa5i8f51856780a9c691@mail.gmail.com> <4671AD7C.4010109@tmr.com> <4671E018.4090105@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4671E018.4090105@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Mike Snitzer <snitzer@gmail.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, nbd-general@lists.sourceforge.net, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: linux-raid.ids

Paul Clements wrote:
> Bill Davidsen wrote:
>
>> Second, AFAIK nbd hasn't working in a while. I haven't tried it in 
>> ages, but was told it wouldn't work with smp and I kind of lost 
>> interest. If Neil thinks it should work in 2.6.21 or later I'll test 
>> it, since I have a machine which wants a fresh install soon, and is 
>> both backed up and available.
>
> Please stop this. nbd is working perfectly fine, AFAIK. I use it every 
> day, and so do 100s of our customers. What exactly is it that not's 
> working? If there's a problem, please send the bug report.
Could you clarify what kernel, distribution, and mdadm version is used, 
and how often the nbd server becomes unavailable to the clients? And 
your clients are SMP? By "working perfectly fine," I assume you do mean 
in the same way as described in the original posting, and not just with 
the client, server, and network all fully functional.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

