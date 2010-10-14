From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: bitmap questions
Date: Thu, 14 Oct 2010 13:11:10 +0100
Message-ID: <4CB6F35E.6040307@anonymous.org.uk>
References: <201010131824.53363.a.miskiewicz@gmail.com> <AANLkTikBAi=NO-uzkvtzwYsgLSf44KuA1VmvXj3d708_@mail.gmail.com> <201010140800.38419.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201010140800.38419.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/10/2010 07:00, Arkadiusz Miskiewicz wrote:
[...]
> So there is no way to know in advance how much is going to be resynced when
> sudden reset would happen in that moment?

Only in the general sense that there's a limit to how many chunks could 
have been dirtied in whatever period your kernel will hang on to stuff 
before insisting on flushing it. I think that defaults to 5 seconds, so 
you'd have to have a pathological workload to dirty so many chunks the 
resync might take more than a minute.

Cheers,

John.

