From: josh <poddmo@gmail.com>
Subject: Re: SMART detects pending sectors; take offline?
Date: Wed, 11 Oct 2017 09:23:42 +1100
Message-ID: <CAC5BxnO9URNuE556Mi0DD=1knf7p0qb3frAGTJa=FK8TvJNxpw@mail.gmail.com>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de> <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org> <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: Reindl Harald <h.reindl@thelounge.net>, Phil Turmel <philip@turmel.org>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Alexander,

On 10 October 2017 at 20:56, Alexander Shenkin <al@shenkin.org> wrote:
> On 10/10/2017 10:11 AM, Reindl Harald wrote:
>>
>>
>>
>> Am 10.10.2017 um 11:00 schrieb Alexander Shenkin:
>>>
>>> Thanks... I know nothing about "check scrubs".  Could you point me to a
>>> good resource?  I've found https://raid.wiki.kernel.org/index.php/Scrubbing
>>> and https://raid.wiki.kernel.org/index.php/Scrubbing_the_drives, but it's
>>> hard to tell exactly how the system should be configured in order to run
>>> these regularly.  A weekly cron perhaps?  And, should it be just check, or
>>> repair?  etc...  Any help you could offer would be welcome.
>>
>>
>> if your distribution don't install a cronjob for that you should blame
>> them because RAID without regular scrub is asking for troubles
>>
>> [root@srv-rhsoft:~]$ rpm -q --file /etc/cron.d/raid-check
>> mdadm-4.0-1.fc26.x86_64
>>
>> [root@srv-rhsoft:~]$ cat /etc/cron.d/raid-check
>> 30 4 * * Mon root /usr/sbin/raid-check
>
>
> Thanks Reindl.  Here's what I have installed (no evidence of raid-check
> available on my system):
>
> $ cat /etc/cron.d/mdadm
> 57 0 * * 0 root if [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d) -le
> 7 ]; then /usr/share/mdadm/checkarray --cron --all --idle --quiet; fi
>


This is indicative of a Debian/Ubuntu distribution. The cron entry is
not enough to enable md array checks, you have to edit
/etc/default/mdadm and set AUTOCHECK=true







>>> Is this something I should run now?  I figure it's a bad idea to push an
>>> array that is starting to degrade... haven't had a chance to replace the
>>> drive yet, but will get to it this week.  Probably best to start the
>>> scrubbing routines once I have 4 good drives in there I figure...
>>
>>
>> NO - never put any load you can avoid on degraded arrays
>
>
> thanks, i won't.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
