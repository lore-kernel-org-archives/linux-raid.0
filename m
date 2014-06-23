From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Fwd: Adding a new drive to an array
Date: Mon, 23 Jun 2014 19:48:46 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1406231947350.18361@uplift.swm.pp.se>
References: <CAG__1a6i-UsOJpy+5GdwV_a-cVDCi_F_5KztwkFbNUEONDhH5w@mail.gmail.com> <alpine.DEB.2.02.1406221931230.18361@uplift.swm.pp.se> <CAG__1a4EG1PNpy_3Zt23OuEaEn1jTsF3-0-o21EQJBRCTPVORg@mail.gmail.com>
 <CAG__1a5M8RKfk1en3j8Cz9hBsPtB+g=znbzOE3hYOZZ2ZgU++g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a5M8RKfk1en3j8Cz9hBsPtB+g=znbzOE3hYOZZ2ZgU++g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 23 Jun 2014, George Duffield wrote:

> What is the purpose of --assume-clean then when man states:
> When  an  array  is resized to a larger size with --grow --size= the
> new space is normally resynced in that  same  way  that  the whole
> array  is  resynced at creation.  From Linux version 3.0,
> --assume-clean can be used with that command to avoid the  automatic
> resync.
> ^^^ What is the automatic resync being referred to in man?

It means the parity blocks are ale correct. If you don't care about this, 
then fine, use --assume-clean.

MD has sensible defaults, don't muck around with them unless you know what 
you're doing.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
