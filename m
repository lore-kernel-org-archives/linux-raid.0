From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Last ditch plea on remote double raid5 disk failure
Date: Mon, 31 Dec 2007 10:38:48 -0500
Message-ID: <47790D08.7000605@tmr.com>
References: <8e0f3ba80712310239w3263b2b8hb62c0a6c79a84b77@mail.gmail.com> <18296.56100.769123.555100@notabene.brown> <4778FA73.7010208@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4778FA73.7010208@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, Marc MERLIN <merlin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Neil Brown wrote:
>   
>> On Monday December 31, merlin@gmail.com wrote:
>>     
>>> I'm hoping that if I can get raid5 to continue despite the errors, I
>>> can bring back up enough of the server to continue, a bit like the
>>> remount-ro option in ext2/ext3.
>>>
>>> If not, oh well...
>>>       
>> Sorry, but it is "oh well".
>>     

> And another thought around all this.  Linux sw raid definitely need
> a way to proactively replace a (probably failing) drive, without removing
> it from the array first.  Something like,
>   mdadm --add /dev/md0 /dev/sdNEW --inplace /dev/sdFAILING
> so that sdNEW will be a mirror of sdFAILING, and once the "recovery"
> procedure finishes (which may use data from other drives in case of
> I/O error reading sdFAILING - unlike described scenario of making a
> superblock-less mirror of sdNEW and sdFAILING),
>   mdadm --remove /dev/md0 /dev/sdFAILING,
> which does not involve any further reconstructions anymore.
>   

I really like that idea, it addresses the same problem as the various 
posts regarding creating little raid1 arrays of the old and new drive, etc.

I would like an option to keep a drive with bad sectors in an array if 
removing the drive would prevent the array from running (or starting). I 
don't think that should be default, but there are times when some data 
is way better than none. I would think the options are fail the drive, 
set the array r/o, and return an error and keep going.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


