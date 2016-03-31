From: Peter Knight <madcornishprojectionist@gmail.com>
Subject: Re: Raid 6 failing to assemble after machine power loss now, with 1
 disk only failed, seems to think its a raid0 array
Date: Thu, 31 Mar 2016 07:09:40 +0100
Message-ID: <CAAgcXJFm=c8kGBrvnoHYOTmpV42_gb+0yRvSNN7p-U-Q7Y_OCg@mail.gmail.com>
References: <CAAgcXJEgLxSaa7x3YO=CuMXS9hPPfPMiUtebQ4RB4F6dmQPd1g@mail.gmail.com>
 <56FC5060.4020502@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56FC5060.4020502@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for the reply Phil.

Unfortunately that didn't work, I get the following message:


root@Wheal-Peevor:~# mdadm --run /dev/md126
mdadm: failed to start array /dev/md126: Input/output error


Thanks

Peter

On 30 March 2016 at 23:17, Phil Turmel <philip@turmel.org> wrote:
> On 03/30/2016 05:19 PM, Peter Knight wrote:
>> Hi,
>>
>> I hope someone can explain what is going on and hopefully help me
>> recover my data.
>
>> What is causing this? and how can I get it reassembled so I can read the data?
>
> When mdadm assembles an array during boot that has fewer devices than
> when it was last shut down (cleanly), it generally declines to start it.
>
> Probably, all you need is:
>
> mdadm --run /dev/md126
>
> { --detail may not be accurate on an inactive device.  The member
> --examine data is trustworthy. }
>
> Phil
