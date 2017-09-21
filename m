From: Phil Turmel <philip@turmel.org>
Subject: Re: Data recovery
Date: Thu, 21 Sep 2017 10:37:12 -0400
Message-ID: <e110978b-92a3-eb52-9d24-1722e34dc81d@turmel.org>
References: <CAEmSg0_=5ni2mA1Q_A1DjZmvjG9u8tKXOQHmnmT33=12yJwYqA@mail.gmail.com>
 <59C309C7.9030300@youngman.org.uk>
 <796e5efe-04af-60c7-4ef0-f9962e456061@turmel.org>
 <CAEmSg09hzYijYix=gc_Nkbr1Ub4YuDGvP--MpEB8UjB=U71onA@mail.gmail.com>
 <54c6f639-0912-1f82-41b9-0a778fb5bb89@turmel.org>
 <CAEmSg08aYMppy6Ardarjz_0P6-HDU8_GCkcOV88g32-T053k_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEmSg08aYMppy6Ardarjz_0P6-HDU8_GCkcOV88g32-T053k_g@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?Vm9qdMSbY2ggS2xldGXEjWth?= <vojta.kletecka@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/21/2017 09:22 AM, Vojtěch Kletečka wrote:
> I tried both reasonable versions without success:

There is only one reasonable version. The one that leaves out the
out-of-sync device.  Your device letters might be changing, as your
mdadm -E reports indicate the one to leave out is /dev/sdd1, active
device #2.

> sudo mdadm --assemble --verbose --force /dev/md127 /dev/sd[ce]1
> [sudo] password for vojtech:
> mdadm: looking for devices for /dev/md127
> mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 2.
> mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 1.
> mdadm: no uptodate device for slot 0 of /dev/md127
> mdadm: added /dev/sdc1 to /dev/md127 as 2 (possibly out of date)
> mdadm: added /dev/sde1 to /dev/md127 as 1
> mdadm: /dev/md127 assembled from 1 drive - not enough to start the array.

I would have thought this would be the correct incantation, but it
identified sdc1 as slot 2.

> sudo mdadm --assemble --verbose --force /dev/md127 /dev/sd[de]1
> mdadm: looking for devices for /dev/md127
> mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 0.
> mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 1.
> mdadm: added /dev/sde1 to /dev/md127 as 1
> mdadm: no uptodate device for slot 4 of /dev/md127
> mdadm: added /dev/sdd1 to /dev/md127 as 0
> mdadm: failed to RUN_ARRAY /dev/md127: Input/output error

This has slots 0 and 1 as expected, but is asking for slot #4. Which
shouldn't be necessary with a 3-device raid10.  Your metadata seems
badly corrupted.

Which means that --create --assume-clean is the right answer, and you
have complete mdadm -E reports to supply the right parameters
(especially chunk size and data offsets) to get it right.  You just have
to make sure you use the correct devices for slots 0 and 1 and supply
'missing' for slot 2.  {Do not use shell [] notation as a shortcut in
any --create command, as [] notation can reorder the letters.}

Phil


