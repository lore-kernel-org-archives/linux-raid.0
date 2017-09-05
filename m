From: Phil Turmel <philip@turmel.org>
Subject: Re: raid5 messed up
Date: Mon, 4 Sep 2017 23:55:18 -0400
Message-ID: <d08b6aaf-208e-f4bf-7d19-139103eb14cd@turmel.org>
References: <fdbb6bf6-357c-781e-beee-d8589cbb299d@email.latech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fdbb6bf6-357c-781e-beee-d8589cbb299d@email.latech.edu>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: bishop@latech.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/01/2017 04:15 PM, Thomas C. Bishop wrote:
> I messed up my raid5 array . I know a two of HDs are "failure
> prediction" and one is out.. seagate is shipping me replacements.
> 
> This is my backup server so there's the actual copy of data but I'd
> prefer to recover the array because other data scripts/tools have crept
> into it ... mostly junk but would like to verify.
> 
> Here's out put as recommended at
> https://raid.wiki.kernel.org/index.php/Linux_Raid
> 
> Thanks in advance for any assistance,

There's a lot of missing data.  lsdrv must have reported not finding
tools that it needs for some of it.  Please add them and run it again.
Other stuff seems to have been trimmed.  Don't do that.  Also, use
"smartctl -iA -l scterc /dev/sdXn" for the smartctl reports.

Please resubmit.

Phil
