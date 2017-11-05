From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID header in XFS area?
Date: Sun, 5 Nov 2017 04:34:19 +0100
Message-ID: <f79ecb93-f005-c03f-d255-5b28a5e9d385@thelounge.net>
References: <CAGRSmLv2HqyZmf-nR4SqnPaw2HNxDAaOSMA-QXVyiekF4Q5x5w@mail.gmail.com>
 <59FE0739.8020400@youngman.org.uk>
 <63581b55-f7bc-4408-aa72-a8a5c7cc37bf@thelounge.net>
 <0fc91932-1fda-7361-f0e6-1121ae502819@youngman.org.uk>
 <df1cda5a-57c3-7f9a-2f93-54ef01c19a30@thelounge.net>
 <59FE36FE.4070705@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59FE36FE.4070705@youngman.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 04.11.2017 um 22:54 schrieb Wols Lists:
> On 04/11/17 20:36, Reindl Harald wrote:
>>>
>>> While the system is RUNNING, yes. But if the array is STOPPED, mdadm
>>> will refuse to start it. At least, that's certainly how I understand
>>> it works ...
>>>
>>> Do you REALLY want the system to be running, and give you no clue that
>>> it's not working properly?
>>
>> mdmon typically writes a mail about a degraded array - so far away from
>> "no clue"
> 
> mdmon? What's that? Yes, I know, it's the monitor. But how do you know
> whether or not it's running? It certainly isn't on my system.

but it should and it#s the responsibility of the admin to ensue it runs 
and it#s mails are properly routed so that you receive them

-------- Weitergeleitete Nachricht --------
Betreff: Fail event on /dev/md0:srv-rhsoft.rhsoft.net
Datum: Wed,  3 Dec 2014 11:32:35 +0100 (CET)
Von: mdadm monitoring <root@srv-rhsoft.rhsoft.net>
An: root@srv-rhsoft.rhsoft.net

This is an automatically generated mail message from mdadm
running on srv-rhsoft.rhsoft.net

A Fail event had been detected on md device /dev/md0.

It could be related to component device /dev/sdb1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

md0 : active raid1 sda1[4] sdb1[3](F) sdd1[0] sdc1[5]
       511988 blocks super 1.0 [4/3] [UUU_]
       unused devices: <none>

> Anyways, as I said, as far as I am aware, "mdadm --run" does NOT work on
> a degraded array unless either the previous --run was on a degraded
> array, or you use --force.
> 
> Which means if you remove a disk from an array, and then try to restart
> the array, the restart will fail. Which is exactly the OP's scenario

and that's what i do not get in general - why should a array not start 
in whatever situation if it has enough drives to do so?

i don't get why a mirrored array should stop at all just becsue it is 
degraded but maybe we talk about completly different things
