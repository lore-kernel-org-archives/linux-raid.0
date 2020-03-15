From: Leslie Rhorer <lesrhorer@att.net>
Subject: Re: checkarray not running or emailing
Date: Sun, 15 Mar 2020 06:11:13 -0500
Message-ID: <411cf191-fccd-b0b2-1be0-a8551ff2cca8@att.net>
References: <814aad65-fba3-334c-c4df-6b8f4bfc4193.ref@att.net>
 <814aad65-fba3-334c-c4df-6b8f4bfc4193@att.net>
 <0ef54c89-b486-eb0b-8d70-a043ef089c9f@att.net>
 <10e2db3d-13e6-573f-18bd-1443d6a27884@fnarfbargle.com>
 <7ba840ec-74fd-96bf-5088-7f8479ddcba5@att.net>
 <61f5fc7b-bd2a-a151-a228-3d2a6f4d3ee6@fnarfbargle.com>
 <baa6f582-e3ea-7668-568b-0b7da2b3a618@att.net>
 <9cd49c13-49bc-3c65-bddf-4862eab50a25@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9cd49c13-49bc-3c65-bddf-4862eab50a25@fnarfbargle.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

     Well, it definitely is not from checkarray, per se, since the 
script completes and exits in a matter of a few milliseconds, but 
something, presumably mdadm does (or at least used to) send status reports:

Subject: Backup-Server mdadm Event Notification

RebuildStarted /dev/md0

RebuildStarted /dev/md3

RebuildFinished /dev/md3

RebuildStarted /dev/md2

RebuildFinished /dev/md2

Rebuild60 /dev/md0

Rebuild80 /dev/md0

RebuildFinished /dev/md0

On 3/13/2020 11:53 AM, Brad Campbell wrote:
> On 13/3/20 08:13, Leslie Rhorer wrote:
>>     Yes, that works just fine, as does the daily email alert whenever 
>> an array is degraded, but `checkarray --cron --all --idle` doesn't 
>> produce an email.  It starts the array verification on all the 
>> arrays, but no status on the processes are sent.
>>
>>     The normal execution for the script is to submit `echo check >  
>> /sys/block/mdx/md/sync_action` and then exit.  Obviously, the rest of 
>> the processes are handled by the scheduler and mdadm. I'm not seeing 
>> how anything other than mdadm should be generating the status emails.
>>
> I don't get messages from checkarray.
>
> I get them from logcheck after they get dumped in the syslog :
>
> This email is sent by logcheck. If you no longer wish to receive
> such mail, you can either deinstall the logcheck package or modify
> its configuration file (/etc/logcheck/logcheck.conf).
>
> System Events
> =-=-=-=-=-=-=
> Mar  1 01:09:17 srv mdadm[4471]: RebuildFinished event detected on md 
> device /dev/md2, component device  mismatches found: 230656 (on raid 
> level 1)
>
>
> (Lots of errors. One drive supports deterministic read after trim and 
> the other doesn't)
>
> I've never really looked at it any closer than that to be honest.
>
> Brad.
