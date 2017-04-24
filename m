From: =?UTF-8?Q?Patrik_Dahlstr=C3=B6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 09:34:04 +0200
Message-ID: <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com> <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org> <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org> <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-24 4:09 GMT+02:00, Brad Campbell <lists2009@fnarfbargle.com>:
> On 24/04/17 03:21, Patrik Dahlstr=C3=B6m wrote:
>
>> I just thought of something: since /dev/sdf is a completely new disk,
>> shouldn't I be able to locate the starting point by looking at how much
>> of the new disk is filled. It comes filled with zeros from factory,
>> right?
>
> Pretty close. You should also be able to see how the reshape worked
> (front to back, back to front) and you should get a pretty good idea of
> the data-offset by the gap between the superblock and the data.
I've let a program compare both raid sets (5 and 6 disk) overnight. So
far it has gone from 128 MB to 14 TB without finding common data. Does
that tell us anything?
Should I pause the comparison and look at the end of sdf to find the
last written offset? I currently only have 1 shell in Ubuntu
maintenance/rescue mode
>
> I must say I'm having trouble imagining a more difficult recovery
> scenario, so at least you present an interesting challenge.
I always like a challenge, but this one I believe I could've skipped :)
>
> There's a lot to be said for the old "Don't panic" mantra, but hindsight
> is always 20/20.
All too true

Best regards
// Patrik
