From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Tue, 8 Nov 2016 13:53:33 -0600
Message-ID: <287df6d6-3850-1142-5c69-c7b54a8a22d4@gmail.com>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
 <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
 <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
 <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
 <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
 <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
 <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
 <57EAA214.8030603@youngman.org.uk>
 <5427ce35-f222-8a2c-486e-441c4c6ec9a6@gmail.com>
 <be044941-8097-7d6f-5216-294fe2cac4d9@websitemanagers.com.au>
 <0f6bd6f6-20ee-1720-23fc-27d206063bfc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0f6bd6f6-20ee-1720-23fc-27d206063bfc@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/08/2016 12:47 PM, Benjammin2068 wrote:
> Hey all,
>
>  I'm still trying to work through this..
>
> I've replaced the cables on the new AOC-SAS2LP-MV8 and the card itself (supermicro sent replacements)
>
>
> but I still occasionally have the mismatch_cnt error.. (like a week will go by and a weekend raid-check will happen with  nothing.)
>
> So -- my question now (as recommended by someone else) is how to see if it's a drive issue somehow. (not that it's a "real" drive issue, but a card firmware issue that's aggravated by a drive's firmware somehow.)
>
> I've looked through the logs -- but how do I trace down a mismatch_cnt? I don't see anything in dmesg or messages....
>
> There are a couple 3Gb/s drives attached to this card.. maybe that's it? Who knows? But I don't have debug info to help me chase it down now that I'm trying to work it out with Supermicro tech support.
>
> Where do I look for more info about source or the event of the mismatch?
>
>

Now that I think about it -- and have been talking out loud to myself (I don't think I'm crazy)...

A parallel to all this is:

I don't think the mismatch_cnt started showing up until I moved from RAID5 to RAID6.

:O

How painful is it to switch back to RAID5 to test that theory?

 -Ben
