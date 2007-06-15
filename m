From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: raid1 with nbd member hangs MD on SLES10 and RHEL5
Date: Thu, 14 Jun 2007 21:16:14 -0400
Message-ID: <4671E85E.30100@steeleye.com>
References: <170fa0d20706121930g3b89ddeex8b31c8923d2a0ff6@mail.gmail.com>	 <170fa0d20706122009h5e3db54ek7487be4940a3d780@mail.gmail.com>	 <18031.25581.353761.802283@notabene.brown>	 <170fa0d20706122130q2c77d365tbe9261bab1a5b1b@mail.gmail.com>	 <170fa0d20706131123q17e4fb9ehe6be25a07462cc30@mail.gmail.com>	 <170fa0d20706131630p6cd29aa5i8f51856780a9c691@mail.gmail.com>	 <4671AD7C.4010109@tmr.com> <4671E018.4090105@steeleye.com>	 <170fa0d20706141801u6d6effd9ub362f3ae397f3d32@mail.gmail.com>	 <4671E5D3.6010903@steeleye.com> <170fa0d20706141810x39cf0c48v645a8292f84a9eb7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20706141810x39cf0c48v645a8292f84a9eb7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, nbd-general@lists.sourceforge.net, Herbert Xu <herbert@gondor.apana.org.au>
List-Id: linux-raid.ids

Mike Snitzer wrote:
> On 6/14/07, Paul Clements <paul.clements@steeleye.com> wrote:
>> Mike Snitzer wrote:
>>
>> > Here are the steps to reproduce reliably on SLES10 SP1:
>> > 1) establish a raid1 mirror (md0) using one local member (sdc1) and
>> > one remote member (nbd0)
>> > 2) power off the remote machine, whereby severing nbd0's connection
>> > 3) perform IO to the filesystem that is on the md0 device to enduce
>> > the MD layer to mark the nbd device as "faulty"
>> > 4) cat /proc/mdstat hangs, sysrq trace was collected
>>
>> That's working as designed. NBD works over TCP. You're going to have to
>> wait for TCP to time out before an error occurs. Until then I/O will 
>> hang.
> 
> With kernel.org 2.6.15.7 (uni-processor) I've not seen NBD hang in the
> kernel like I am with RHEL5 and SLES10.  This hang (tcp timeout) is
> indefinite oh RHEL5 and ~5min on SLES10.
> 
> Should/can I be playing with TCP timeout values?  Why was this not a
> concern with kernel.org 2.6.15.7; I was able to "feel" the nbd
> connection break immediately; no MD superblock update hangs, no
> longwinded (or indefinite) TCP timeout.

I don't know. I've never seen nbd immediately start returning I/O 
errors. Perhaps something was different about the configuration?
If the other other machine rebooted quickly, for instance, you'd get a 
connection reset, which would kill the nbd connection.

--
Paul
