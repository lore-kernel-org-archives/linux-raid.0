From: Phil Turmel <philip@turmel.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Wed, 3 Jan 2018 11:02:19 -0500
Message-ID: <6572ed42-8559-84eb-0468-7823786c3001@turmel.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
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
 <07170cf8-d951-013b-7e67-eee54aa60c65@shenkin.org>
 <61e91b55-5b96-143e-15c8-4a320f89eeb2@turmel.org>
 <ae183814-248b-2d45-8074-85787fcd0d61@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ae183814-248b-2d45-8074-85787fcd0d61@shenkin.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Brad Campbell <lists2009@fnarfbargle.com>, Reindl Harald <h.reindl@thelounge.net>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/03/2018 10:59 AM, Alexander Shenkin wrote:
> On 1/3/2018 3:53 PM, Phil Turmel wrote:
>> On 01/03/2018 08:50 AM, Alexander Shenkin wrote:
>>> On 1/3/2018 1:26 PM, Brad Campbell wrote:
>>
>>>> Nope. Your pending is still at 8, so you've got bad sectors in an area
>>>> of the drive that hasn't been dealt with. What is "interesting" is
>>>> that your SMART test results don't list the LBA of the first failure.
>>>> Disappointing behaviour on the part of the disk. They are within the
>>>> 1st 10% of the drive however, so it wouldn't surprise me if they were
>>>> in an unused portion of the RAID superblock area.
>>>
>>> Thanks Brad.  So, to theoretically get these sectors remapped so I don't
>>> keep getting errors, I would have to somehow try to write to those
>>> sectors.  That's tough given that the LBA's aren't reported as you
>>> mention.  Perhaps my best course of action then is to:
>>
>> No, just use dd to read that device -- it'll bail out with read error
>> when it hits the trouble spot, which will report the affected sector.
>> Then you can rewrite it with the appropriate seek= value.  (Assuming it
>> really is in an unused part of the member device.)
> 
> Thanks Phil.  So, just: dd if=/dev/sda of=/dev/null bs=512

Yup. (-:

Phil
