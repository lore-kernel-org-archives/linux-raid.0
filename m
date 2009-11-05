From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Doubt
Date: Wed, 4 Nov 2009 23:42:14 -0800
Message-ID: <4877c76c0911042342v7fcd67c4j120b2addf99eabba@mail.gmail.com>
References: <d3540f4d0911042326o754d5f06qf958d8ab5b309e86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d3540f4d0911042326o754d5f06qf958d8ab5b309e86@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Light King <thelightking@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Your requirements are contradictory.  You want to span all your
devices with a single storage system, but you do not want to use any
devices for redundancy and expect the filing system on them to remain
consistent should any of the devices fail.

That is simply impossible for file-systems, which is what block-device
aggregation such as mdadm is designed to support.  Were you to loose
any random device out of the four portions of the filesystem metadata
as well as your actual data would be missing.  That may be tolerable
for special cases (regularly sampled data, such as sensor outputs
comes to mind, when you don't -require- the sensor data, but merely
want to have it), however those cases are all application specific,
not general solution.

One typical way a specific application might use four devices would be
a round-robin method.  In this a list of currently online devices
would be kept, then each cohesive unit would be stored to the next
device in the list.  Should a device be added the list would grow,
should a device fail (be removed) it would be taken out of the list.

You have four choices then:

1) What I described above
2) A Raid 0 that gives you 100% storage, but all devices working or none.
3) A Raid 1+0 or 10 (same idea different drivers) solution, you're
already trying it and disliking it though.
4) Raid 5; you spend more CPU but you use one of the devices for
recovery data, so that you can tolerate a single failure.
5) Technically you might also have raid 6; but I'm not counting it
because you're already complaining about loosing 50% of your data and
this has the addition of being slower (BUT surviving -literally- any 2
devices, instead of any 1 device of the correct set.)
