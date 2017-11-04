From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID header in XFS area?
Date: Sat, 4 Nov 2017 21:54:06 +0000
Message-ID: <59FE36FE.4070705@youngman.org.uk>
References: <CAGRSmLv2HqyZmf-nR4SqnPaw2HNxDAaOSMA-QXVyiekF4Q5x5w@mail.gmail.com>
 <59FE0739.8020400@youngman.org.uk>
 <63581b55-f7bc-4408-aa72-a8a5c7cc37bf@thelounge.net>
 <0fc91932-1fda-7361-f0e6-1121ae502819@youngman.org.uk>
 <df1cda5a-57c3-7f9a-2f93-54ef01c19a30@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <df1cda5a-57c3-7f9a-2f93-54ef01c19a30@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/17 20:36, Reindl Harald wrote:
>>
>> While the system is RUNNING, yes. But if the array is STOPPED, mdadm
>> will refuse to start it. At least, that's certainly how I understand
>> it works ...
>>
>> Do you REALLY want the system to be running, and give you no clue that
>> it's not working properly?
> 
> mdmon typically writes a mail about a degraded array - so far away from
> "no clue"

mdmon? What's that? Yes, I know, it's the monitor. But how do you know
whether or not it's running? It certainly isn't on my system.

Anyways, as I said, as far as I am aware, "mdadm --run" does NOT work on
a degraded array unless either the previous --run was on a degraded
array, or you use --force.

Which means if you remove a disk from an array, and then try to restart
the array, the restart will fail. Which is exactly the OP's scenario.

Cheers,
Wol
