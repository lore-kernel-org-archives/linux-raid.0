From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID header in XFS area?
Date: Sat, 4 Nov 2017 21:36:09 +0100
Message-ID: <df1cda5a-57c3-7f9a-2f93-54ef01c19a30@thelounge.net>
References: <CAGRSmLv2HqyZmf-nR4SqnPaw2HNxDAaOSMA-QXVyiekF4Q5x5w@mail.gmail.com>
 <59FE0739.8020400@youngman.org.uk>
 <63581b55-f7bc-4408-aa72-a8a5c7cc37bf@thelounge.net>
 <0fc91932-1fda-7361-f0e6-1121ae502819@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0fc91932-1fda-7361-f0e6-1121ae502819@youngman.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Wol's lists <antlists@youngman.org.uk>, "David F." <df7729@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 04.11.2017 um 20:27 schrieb Wol's lists:
> On 04/11/17 18:34, Reindl Harald wrote:
>>> What's happened is that mdadm has assembled the array, realised a disk
>>> is missing, AND STOPPED.
>>
>> why would it be supposed that a simple mirror with a mising disk is 
>> stopped while the whole point of mirroring is to not care about one of 
>> the disks dying?
> 
> While the system is RUNNING, yes. But if the array is STOPPED, mdadm 
> will refuse to start it. At least, that's certainly how I understand it 
> works ...
> 
> Do you REALLY want the system to be running, and give you no clue that 
> it's not working properly?

mdmon typically writes a mail about a degraded array - so far away from 
"no clue"
