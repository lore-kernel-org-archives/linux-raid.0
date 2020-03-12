From: Leslie Rhorer <lesrhorer@att.net>
Subject: Re: checkarray not running or emailing
Date: Wed, 11 Mar 2020 20:17:27 -0500
Message-ID: <b311da95-8773-65f4-30d2-e4e2d5e2f0a9@att.net>
References: <814aad65-fba3-334c-c4df-6b8f4bfc4193.ref@att.net>
 <814aad65-fba3-334c-c4df-6b8f4bfc4193@att.net>
 <0ef54c89-b486-eb0b-8d70-a043ef089c9f@att.net>
 <5E68D6D9.5040004@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E68D6D9.5040004@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

     Well, that is rather the point, actually.  I can't find anywhere 
that Debian *DID* run the script in the previous versions.  Failing 
that, either Debian was doing it somewhere of which I have no knowledge, 
or else mdadm itself was running it. Since mdadm itself does have some 
timers built-in, the latter is not a totally unreasonable method of 
handling the situation, hence my query to the list.

     To the rest, I wasn't offended.  My skin is much thicker than 
that.  More to the point, my desire to get this fix is the entire 
concern of this thread.  My ego isn't involved.

On 3/11/2020 7:17 AM, Wols Lists wrote:
> On 11/03/20 01:11, Leslie Rhorer wrote:
>>      Is there seriously no one here who knows how checkarray was launched
>> in previous versions?
> You need to ask on a Debian list. I for one don't have a damn clue
> because I actively avoid apt-based systems.
>
> Sorry, I don't mean to be harsh, but each distro "does its own thing" so
> a lot of people (like me) *will* be clueless on that point, even if we
> are raid experts.
>
> Cheers,
> Wol
>> On 3/1/2020 3:03 PM, Leslie Rhorer wrote:
>>>      I have upgraded 2 of my servers to Debian Buster, and now neither
>>> one seems to be running checkarray automatically.  In addition, when I
>>> run checkarray manually, it isn't sending update emails on the status
>>> of the job.  Actually, I have never been able to figure out how
>>> checkarray runs.  One my older servers, there doesn't seem to be
>>> anything in /etc/crontab, /etc/cron.monthly, /etc/init.d/,
>>> /etc/mdadm/mdadm.conf, or /lib/systemd/system/ that would run checkarray.
