From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: what does md do if it finds an inconsistency?
Date: Tue, 08 May 2007 09:27:53 -0400
Message-ID: <46407AD9.1060400@tmr.com>
References: <20070506004539.GA17736@lapse.madduck.net>    <20070506090642.GA22083@lapse.madduck.net>    <463DB709.8010900@eyal.emu.id.au> <3655.195.137.231.42.1178458574.squirrel@albatross.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3655.195.137.231.42.1178458574.squirrel@albatross.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

martin f krafft wrote:
>> The first time it reports that it found (and repaired) 128 items.
>> It does not mean that you now *have* 128 mismatches.
>>
>> The next run ('repair' or 'check') will find none (hopefully...)
>> and report zero.
>>     
>
> Oh, this makes perfect sense, thanks for the explanation.
>
> As the mdadm maintainer for Debian, I would like to come up with a way to
> handle mismatches somewhat intelligently. I already have the check
> sync_action run once a month on all machines by default (can be turned
> on/off via debconf), and now I would like to find a good way to react when
> mismatch_count is non-zero. I don't want to write to the components
> without the admin's consent though.
>   
That sounds right. Some arrarys have persistent mismatches if they are 
in use, you are unlikely to want to even attempt to take corrective 
action. You might want to have a config file and just run a program 
which reads the config regularly and acts based on what it finds.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

