From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: mdadm 3.4-1, error msg. on boot - no
 /usr/lib/systemd/scripts/mdadm_env.sh
Date: Wed, 8 Jun 2016 17:06:38 -0500
Message-ID: <575896EE.4020502@suddenlinkmail.com>
References: <5754CBF2.8000309@suddenlinkmail.com>
 <wrfjziqwyex7.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjziqwyex7.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/07/2016 02:31 PM, Jes Sorensen wrote:
> "David C. Rankin" <drankinatty@suddenlinkmail.com> writes:
>> Neil, All,
>>
>>   I'm chasing down the reason there is no
>> /usr/lib/systemd/scripts/mdadm_env.sh provided with mdadm. This is
>> more a curiosity really as mdmonitor continues to run, but it always
>> throws an error at boot:
>>
>> Jun 05 17:12:47 valhalla systemd[454]: mdmonitor.service: Failed at step EXEC
>> spawning /usr/lib/systemd/scripts/mdadm_env.sh: No such file or directory
>>
>>   I have several Arch servers, all on mdadm 3.4-1. I ran into an issue
>> a year or so ago with a boot error with mdmonitor due to my failure to
>> provide MAILADDR in /etc/mdadm.com, but that has long since been
>> corrected:
> 
> If you're running Arch Linux, you probably want to direct this question
> to the Arch Linux maintainers.
> 
> Jes
> 

Thank you Jes,

  I've posed the problem back to the Arch devs.

-- 
David C. Rankin, J.D.,P.E.
