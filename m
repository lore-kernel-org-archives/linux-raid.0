From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Wed, 17 Nov 2004 11:21:25 +0000
Message-ID: <419B3435.3080707@dgreaves.com>
References: <200411132039.iADKdDN07474@www.watkins-home.com> <41968282.6060306@dgreaves.com> <4198DF79.8080809@dgreaves.com> <41999A9B.2000907@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <41999A9B.2000907@wasp.net.au>
Sender: linux-ide-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Guy <bugzilla@watkins-home.com>, =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mru@inprovide.com>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell wrote:

> David Greaves wrote:
>
>> Now all I need is SMART through libata.
>
>
> If you are using a UP system, grab the patches from Jeff's libata-dev 
> tree and have at it.
> I have been beating it hard on 14 drives here on a loaded working 
> server for weeks and have not managed to toast anything yet. It's 
> great being able to keep tabs on the remaining whirly bits and 
> hopefully get an early warning before they expire.
>
> (Fingers crossed. 12 of them are Maxtor Maxline-II drives but all sit 
> between 35 & 40 deg C)
>
> Brad

Thanks Brad
I've been tracking this on the ide list and I've been nervous of 
applying anything since I don't have proper  backups. I'm relying on 
redundancy.

I also found this comment by Jeff on some patches:
  As I noted in another email, be careful...  that patch bypasses the 
SCSI command synchronization, so you could potentially send a SMART 
command to the hardware while another command is still in progress.
He follows up by saying this *will* result in corruption.

And although I *think* he was refering to an earlier incarnation...

I looked to see what I'd need to do and given I'm running 2.6.9 I take 
it I'd have to apply:
  
http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/2.6.9-libata1-dev1.patch.bz2
which depends on
  
http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/2.6.9-libata1.patch.bz2

That seems like quite a lot and I'm not clear on the level of stability 
impact on my system.

Now although I track linux-ide I doubt I'm fully informed!!
So if anyone would like to inform me of a reasonable course of action 
then I'm actually reasonably happy to apply the SMART patch.

David

