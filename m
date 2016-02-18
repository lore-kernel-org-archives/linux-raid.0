From: Bruce Dubbs <bruce.dubbs@gmail.com>
Subject: Re: mdadm regression tests, slight progress
Date: Thu, 18 Feb 2016 14:20:18 -0600
Message-ID: <56C62782.7020101@gmail.com>
References: <56C4F8A4.2080909@gmail.com> <wrfjoabdygec.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjoabdygec.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jes Sorensen wrote:

>> What I did was add a couple of 'cat /proc/mdstat' commands where the
>> script was failing.  At Point 1 above, I got:
>>
>> ++ cat /proc/mdstat
>> Personalities : [raid1] [raid10] [raid6] [raid5] [raid4] [multipath]
>> md127 : inactive md0[0](S)
>>        19904 blocks
>>
>> md0 : active raid1 loop1[1] loop0[0]
>>        20000 blocks super non-persistent [2/2] [UU]
>>        [==>..................]  resync = 12.5% (2688/20000)
>> finish=0.1min speed=2688K/sec
>>
>>
>> The line with resync looked suspicious so at that point I added a
>> 'sleep 10' command.  The test now passes.
>>
>> The full log is at
>> http://anduin.linuxfromscratch.org/~bdubbs/files/mdadm-test1.log
>>
>> Does anyone know what is going on to need this sleep in order for this
>> test to pass?
>
> It sounds to like the thing hangs if you try to stop the array before
> the resync completes. That could be a race in the kernel code.

Thanks.  I'll try a different kernel version and report back.  The above 
was tested with kernel version 4.2.0.

   -- Bruce


