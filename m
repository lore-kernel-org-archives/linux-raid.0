From: Phil Turmel <philip@turmel.org>
Subject: Re: raid/device failure
Date: Sun, 10 Feb 2013 22:44:00 -0500
Message-ID: <51186900.4000608@turmel.org>
References: <201302101827.36116.thomas@fjellstrom.ca> <511852EF.9070201@turmel.org> <51185CDF.8000007@ejane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51185CDF.8000007@ejane.org>
Sender: linux-raid-owner@vger.kernel.org
To: EJ Vincent <ej@ejane.org>
List-Id: linux-raid.ids

On 02/10/2013 09:52 PM, EJ Vincent wrote:
> On 2/10/2013 9:09 PM, Phil Turmel wrote:
>> Have these drives ever been scrubbed? (I vaguely recall you mentioning
>> new drives...) If they are new and already had a URE, I'd be concerned
>> about mishandling during shipping. If they aren't new, I'd
>> destructively exercise them and retest.
> 
> Hi Phil,
> 
> Could you elaborate on procedures and tools to thoroughly exercise newly
> purchased drives? Are you talking about programs such as 'badblocks'?

Yes, badblocks is convenient because it is part of e2fsprogs, which
pretty much ships by default in all distros.

What I recommend:

Record the complete drive status as unpacked:
1) smartctl -x /dev/sdX >xxxx-as-received.smart.txt

Userspace surface check:
2) badblocks -w -b 4096 /dev/sdX

Security erase (vital for SSDs):
3a) hdparm --user-master u --security-set-pass password /dev/sdX
3b) hdparm --user-master u --security-erase password /dev/sdX

(wait until done)

Long drive self-test:
4) smartctl -t long /dev/sdX

(wait until done)

Record the complete drive status post-test:
5) smartctl -x /dev/sdX >xxxx-as-tested.smart.txt

I won't accept any reallocations in a new drive, and no more than single
digits in older drives.  In my (subjective) experience, once
reallocations get into double digits, their incidence seems to accelerate.

I also pay extra attention to desktop drives with 30,000+ hours, as I
haven't had any get to 40,000.

Phil
