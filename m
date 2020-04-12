From: Jonas Fisher <fisherthepooh@protonmail.com>
Subject: RAID0 with only one zone
Date: Sun, 12 Apr 2020 07:41:16 +0000
Message-ID: <U_VZCfOb6kXQkP0UHckeJnw9xb4SWfhBpSIccNq-gB0B1EugPbxRIKu2eFjpOucWClEneY__W8pBJHBdkfAK5KuNC3mHiN19knwIDOOQZdU=@protonmail.com>
Reply-To: Jonas Fisher <fisherthepooh@protonmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I got four disks with different size, and I want to create a raid0,
I think I would expand it in the future, but the only way to expand
a raid0 is to convert it to raid4 and convert it back to raid0.
But there's a limitation that there should be only one zone in
this raid0, I tried to specify --size on creation to limit
the disk size to the smallest one, but I found it not working,
I still got more than one zone.

It seems weird that multi-zones are created even though I've
specified the device size... Or, is there any way I can create
a raid0 with only 1 zone if I use the disks with different size?

Any enlightenment is appreciated. Thanks.
