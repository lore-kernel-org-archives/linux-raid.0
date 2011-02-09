From: Chris Worley <worleys@gmail.com>
Subject: Re: SSD - TRIM command
Date: Wed, 9 Feb 2011 08:52:55 -0700
Message-ID: <AANLkTim-S0nTC8-r1U2xQ9Gw3EVAZHDjSxT=tnNnHmCT@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Scott E. Armitage" <launchpad@scott.armitage.name>
Cc: Roberto Spadim <roberto@spadim.com.br>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 9, 2011 at 8:00 AM, Scott E. Armitage
<launchpad@scott.armitage.name> wrote:
<snip>
>AFAICT, reading back a trimmed page is
> not defined

... and so should be assumed that reading a trimmed/nonexistant LBA
off of two of the same vendor's SSD's would realize different results?
