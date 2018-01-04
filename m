From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: SMART detects pending sectors; take offline?
Date: Thu, 4 Jan 2018 21:16:27 +0800
Message-ID: <97c75be5-1988-0e66-0d50-f06188418b3b@fnarfbargle.com>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
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
 <6572ed42-8559-84eb-0468-7823786c3001@turmel.org>
 <7bce6228-0695-ff30-7cc0-60486be128ff@shenkin.org>
 <c24ffbc6-6ba6-ef04-76f3-2217fe5f4926@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c24ffbc6-6ba6-ef04-76f3-2217fe5f4926@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/01/18 20:28, Alexander Shenkin wrote:

>
>
> Ok, an update.  Writing with bs=512 had issues, as it was failing on a 
> read, and reallocating was failing.  I think this is because the 
> physical sector size is 4096b, and it needs to read the other 7 512b 
> logical sectors if it wants to write just 1 512b logical sector.  So, 
> I ran:
>
> sudo dd if=/dev/zero of=/dev/sda seek=732230414 count=1 bs=4096
>
> This seems to have worked.  In syslog, I just now saw:
>
> Jan  4 12:12:07 machinename smartd[2203]: Device: /dev/sda [SAT], No 
> more Currently unreadable (pending) sectors, warning condition reset 
> after 90 emails
> Jan  4 12:12:07 machinename smartd[2203]: Device: /dev/sda [SAT], No 
> more Offline uncorrectable sectors, warning condition reset after 90 
> emails
> Jan  4 12:12:07 machinename smartd[2203]: Device: /dev/sda [SAT], 
> SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 113 to 117
>
> I'm now running a checkarray and will report back final results, and 
> whether the SMART warnings return.  Thanks all for the help, hope this 
> marks the end of this issues...
>
> Allie
>

Damn. I saw your initial mail, but I was out and nowhere near a device I 
could use to reply sensibly.
You should *really* check by looking at the mdadm --examine output and 
calculating the position of the sectors in question to be absolutely 
sure the area you just wrote over was not in the active array area. If 
it was then you should stop the checkarray *now* and come back for advice.

Sorry I don't have time right now to elaborate.

Regards,
-- 

Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.

