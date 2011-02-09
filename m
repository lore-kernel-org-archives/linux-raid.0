From: "Eric D. Mudama" <edmudama@bounceswoosh.org>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 09:19:16 -0700
Message-ID: <20110209161916.GB8632@bounceswoosh.org>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
 <4D517F4F.4060003@gmail.com>
 <4D5245DF.4020401@hardwarefreak.com>
 <iiu4rc$9ju$1@dough.gmane.org>
 <AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
 <AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Scott E. Armitage" <launchpad@scott.armitage.name>
Cc: Roberto Spadim <roberto@spadim.com.br>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb  9 at 10:00, Scott E. Armitage wrote:
>I reiterate my previous reply that under the current md architecture,
>where the complete device is considered to be in use, sending TRIM
>commands makes little sense. AFAICT, reading back a trimmed page is
>not defined, since the whole idea is that the host doesn't care about
>what is on that page any more.
>
>The next time md comes around to corresponding trimmed pages on two
>SSDs, their contents may differ, and all of a sudden our array is no
>longer consistent.

For SATA devices, ATA8-ACS2 addresses this through Deterministic Read
After Trim in the DATA SET MANAGEMENT command.  Devices can be
indeterminate, determinate with a non-zero pattern (often all-ones) or
determinate all-zero for sectors read after being trimmed.

--eric

-- 
Eric D. Mudama
edmudama@bounceswoosh.org

