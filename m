From: Eric Valette <eric.valette@free.fr>
Subject: Re: Problem with array raid10 array resync on 4.4.0 (keeps reyncing
 each reboot)
Date: Thu, 4 Feb 2016 07:57:47 +0100
Message-ID: <56B2F66B.2020102@free.fr>
References: <56A78786.10103@Free.fr> <20160126233133.GB12721@kernel.org>
 <56A870AD.4070400@free.fr> <20160128182522.GB23378@kernel.org>
 <56AA7176.1020508@free.fr> <56AE9214.3030206@free.fr>
 <20160204011731.GA29132@kernel.org>
Reply-To: eric.valette@free.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160204011731.GA29132@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/02/2016 02:17, Shaohua Li wrote:
> On Mon, Feb 01, 2016 at 12:00:36AM +0100, Eric Valette wrote:
>> On 28/01/2016 20:52, Eric Valette wrote:
>>> On 28/01/2016 19:25, Shaohua Li wrote:
>>>
>>> If really needed can rebuild a 4.4 kernel and boot it. What do you mean
>>> by special config? I can send you my kernel .config once rebuild
>>> (oldconfig from 4.1.16)
>>
>> Linux nas2 4.4.1 #1 SMP Sun Jan 31 23:46:26 CET 2016 x86_64 GNU/Linux
>
> Nothing useful. Did you try stop the array and reassemble it in 4.4 and check
> if resync runs? I can only imagine the reboot script didn't clean shutdown the
> array and trigger the issue. A stop/reassemble circle will tell us if this is
> the issue.

If the issue was in the script it would happen with all the kernel 
version no? Si far 3.14, 3.18, 4.1 works correctly (when upgrading). 
Only 4.4 fails.

4.4 in fact seems to fails to boot the first time I boot it. As I have 
no console normally, I have to shut down via power button and then it 
resync. I can understand this behavior but not
	1) that the resync fails each time and
	2) that it fails to boot the first time I change for a 4.4 kernel.

-- eric

