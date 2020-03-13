From: Leslie Rhorer <lesrhorer@att.net>
Subject: Re: checkarray not running or emailing
Date: Thu, 12 Mar 2020 19:24:56 -0500
Message-ID: <5caf739c-ecf4-7033-eaf2-bb498ec699f4@att.net>
References: <814aad65-fba3-334c-c4df-6b8f4bfc4193.ref@att.net>
 <814aad65-fba3-334c-c4df-6b8f4bfc4193@att.net>
 <0ef54c89-b486-eb0b-8d70-a043ef089c9f@att.net>
 <10e2db3d-13e6-573f-18bd-1443d6a27884@fnarfbargle.com>
 <7ba840ec-74fd-96bf-5088-7f8479ddcba5@att.net>
 <f4d8ab8d-90cb-e9d0-3b15-ceab881dfcc1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f4d8ab8d-90cb-e9d0-3b15-ceab881dfcc1@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/11/2020 11:53 PM, Ram Ramesh wrote:
> This may be a silly question, but is email working in your system?

     It's not a silly question, but I believe I already answered it.  
Yes, email is working, and yes, mdadm is able to send messages.  It 
complains every morning at 07:35 if one f the arrays is degraded, and 
the test function works.

> I run debian, but a different version. Cron only sends me a message 
> when something is wrong. I mean if checkarray failed, I get a message. 
> If my array is degraded, I get a message. If everything is fine, no 
> message. May be that is the standard. I am not the authority, but that 
> is what is happening in my system.

     I don't believe cron sends the messages for the array redundancy 
check, since they are sent roughly every 20% of the sync task, not on 
any particular time schedule.  Of course, the status check is run by 
some timer, and cron could certainly handle such a task on a 
minute-by-minute basis, but I don't see any cron task related to the 
array structure other than /etc/cron.d/mdadm, which is the checkarray 
task itself, run once a month.

> I believe cron emails stdout+stderr of the command run. May be 
> checkarray does not output anything in a successful run and therefore 
> no email.

     Checkarray normally doesn't output anything when run fro, the cron 
task, which employs the --quiet switch, nor does cron if checkarray is 
successful.  It merely initiates the check action on every specified 
array and exits.  Something else - presumably mdadm - sends an email as 
the array check proceeds every 20%.

> It is best to also query debian.user email: debian-user@lists.debian.org
         I will try querying the Debian list, but while the cron job was 
a Debian feature, I don't believe this issue is one with Debian, per se.
> Ramesh
>
> On 3/11/20 8:41 PM, Leslie Rhorer wrote:
>>     Aha! There it is, on both the old and new systems, so it probably 
>> is running.  The question remains, "Why isn't it posting to email?"
>>
>> On 3/11/2020 7:50 AM, Brad Campbell wrote:
>>> On 11/3/20 09:11, Leslie Rhorer wrote:
>>>>      Is there seriously no one here who knows how checkarray was 
>>>> launched in previous versions?
>>>>
>>>> On 3/1/2020 3:03 PM, Leslie Rhorer wrote:
>>>>>     I have upgraded 2 of my servers to Debian Buster, and now 
>>>>> neither one seems to be running checkarray automatically.  In 
>>>>> addition, when I run checkarray manually, it isn't sending update 
>>>>> emails on the status of the job.  Actually, I have never been able 
>>>>> to figure out how checkarray runs.  One my older servers, there 
>>>>> doesn't seem to be anything in /etc/crontab, /etc/cron.monthly, 
>>>>> /etc/init.d/, /etc/mdadm/mdadm.conf, or /lib/systemd/system/ that 
>>>>> would run checkarray.
>>>>
>>>
>>> On mine it's in /etc/cron.d/mdadm
>>>
>>> brad@srv:/etc/cron.d$ cat mdadm
>>> #
>>> # cron.d/mdadm -- schedules periodic redundancy checks of MD devices
>>> #
>>> # Copyright © martin f. krafft <madduck@madduck.net>
>>> # distributed under the terms of the Artistic Licence 2.0
>>> #
>>>
>>> # By default, run at 00:57 on every Sunday, but do nothing unless 
>>> the day of
>>> # the month is less than or equal to 7. Thus, only run on the first 
>>> Sunday of
>>> # each month. crontab(5) sucks, unfortunately, in this regard; 
>>> therefore this
>>> # hack (see #380425).
>>> 57 0 * * 0 root if [ -x /usr/share/mdadm/checkarray ] && [ $(date 
>>> +\%d) -le 7 ]; then /usr/share/mdadm/checkarray --cron --all --idle 
>>> --quiet; fi
>>>
>>> dpkg -L mdadm gave me a list of files and I just checked the cron 
>>> entries.
>>>
>>> I don't run anything that recent, but Debian is Debian.
>>>
>>> Brad
