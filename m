From: =?UTF-8?Q?Patrik_Dahlstr=C3=B6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 16:05:39 +0200
Message-ID: <CAHKno4BwvVTtwqrHjTF8seSgR-QArmvATwuNy_21ctUPdh0biA@mail.gmail.com>
References: <20170423144835.GB12093@metamorpher.de> <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
 <20170423154240.GA3494@metamorpher.de> <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
 <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com> <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de> <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de> <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170424133946.GA7057@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-24 15:39 GMT+02:00, Andreas Klauer <Andreas.Klauer@metamorpher.de>:
> On Mon, Apr 24, 2017 at 02:54:50PM +0200, Patrik Dahlstr=C3=B6m wrote:
>> What offset are you referring to here? The --data-offset to the mdadm
>> --create command?
>
> Yes, data offset...
It all makes sense to me now! I believe I was still in sort of a
panicked mode yesterday. The pieces are starting to make more sense
today.

> Another thing you can check is, pick an arbitrary offset that does not
> have zeroes on the disks, and see if the XOR matches for 5, or 6 disks.
I will try that when I get home.
>
> If you have a 5disk parity match in the zone that should be 6disks,
> then maybe one of your earlier mdadm create experiments started to
> sync the raid.
This is definitely a possibility.
>
> This would be yet another nail in your coffin.
Could you define how big nail? I can live with some data loss, but
preferably not 20 TB.

Best regards
Patrik Dahlstr=C3=B6m
