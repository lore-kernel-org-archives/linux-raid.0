From: Alexander Shenkin <al@shenkin.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Wed, 3 Jan 2018 13:50:04 +0000
Message-ID: <07170cf8-d951-013b-7e67-eee54aa60c65@shenkin.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
 <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org>
 <59DF4B80.5010807@youngman.org.uk>
 <ecbbf0ae-3bf8-fe66-79e1-e8207bc09dcc@turmel.org>
 <5b28b0fc-5e4d-9ac3-9a82-7e36f25c5108@shenkin.org>
 <CAK2H+ecT1Psph5Wm9LrPgYOba6PHKzAs55H1LWiqLD+kaBUQZQ@mail.gmail.com>
 <CACsGCyQGZxhfT1A_ojXaBRvB4wgNOH7fqqh8afsQksAeGdKmjg@mail.gmail.com>
 <CACsGCyS9-K4ZJPKauRZkGFRPd0cvShYLViE87i47=RCY1UkbnQ@mail.gmail.com>
 <fcb32200-19f7-5513-24a0-70ca15ca6297@shenkin.org>
 <7bf0a71e-6cb7-59bc-695b-54ed6b08112b@turmel.org>
 <d86c80ba-7703-1591-7816-00d0d9408386@shenkin.org>
 <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org>
 <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org>
 <201ea04e-1a03-fc83-c31c-146b50bb8624@thelounge.net>
 <47ec07c3-25ae-9595-78a2-8420c106f2a0@fnarfbargle.com>
 <20497c70-140d-c4dd-0201-816477bd467f@shenkin.org>
 <14f1fce1-2959-e051-f7c8-1d98951d744a@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14f1fce1-2959-e051-f7c8-1d98951d744a@fnarfbargle.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Reindl Harald <h.reindl@thelounge.net>, Phil Turmel <philip@turmel.org>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/3/2018 1:26 PM, Brad Campbell wrote:
> 
> 
> On 03/01/18 20:44, Alexander Shenkin wrote:
>> On 12/23/2017 3:14 AM, Brad Campbell wrote:
>>> On 21/12/17 19:38, Reindl Harald wrote:
>>>>
>>>>
>>>> Am 21.12.2017 um 12:28 schrieb Alexander Shenkin:
>>>>> Hi all,
>>>>>
>>>>> Reporting back after changing the hangcheck timer to 180 secs and 
>>>>> re-running checkarray.  I got a number of rebuild events (see 
>>>>> syslog excerpts below and attached), and I see no signs of the 
>>>>> hangcheck issue in dmesg like I did last time.
>>>>>
>>>>> I'm still getting the SMART OfflineUncorrectableSector and 
>>>>> CurrentPendingSector errors, however.  Should those go away if the 
>>>>> rewrites were correctly carried out by the drive? Any thoughts on 
>>>>> next steps to verify everything is ok?
>>>>
>>>> OfflineUncorrectableSector unlikely can go away
>>>>
>>>> CurrentPendingSector
>>>> https://kb.acronis.com/content/9133
>>>
>>> If they've been re-written (so are no longer pending) then a SMART 
>>> long or possibly offline test will make them go away. I use SMART 
>>> long myself.
>>>
>>
>> Thanks Brad.  I'm running a long test now, but I believe I have the 
>> system set up to run long tests regularly, and the issue hasn't been 
>> fixed.  Furthermore, strangely, the reallocated sector count still 
>> sits at 0 (see below).  If these errors had been properly handled by 
>> the drive, shouldn't Reallocated_Sector_Ct sit at least at 8?
> 
> Nope. Your pending is still at 8, so you've got bad sectors in an area 
> of the drive that hasn't been dealt with. What is "interesting" is that 
> your SMART test results don't list the LBA of the first failure. 
> Disappointing behaviour on the part of the disk. They are within the 1st 
> 10% of the drive however, so it wouldn't surprise me if they were in an 
> unused portion of the RAID superblock area.

Thanks Brad.  So, to theoretically get these sectors remapped so I don't 
keep getting errors, I would have to somehow try to write to those 
sectors.  That's tough given that the LBA's aren't reported as you 
mention.  Perhaps my best course of action then is to:

1) re-run sudo /usr/share/mdadm/checkarray --idle --all
2) add my previously-purchased drive to convert the RAID5 to RAID6 
(using 
http://www.ewams.net/?date=2013/05/02&view=Converting_RAID5_to_RAID6_in_mdadm 
as a guide)
3) after that, fail and remove /dev/sda from the RAID6
4) write 0's on /dev/sda (dd if=/dev/zero of=/dev/sda bs=1M)
5) re-add /dev/sda to the RAID6

This should get those bad sectors remapped...  thoughts?

thanks,
allie
