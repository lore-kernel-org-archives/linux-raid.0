From: =?UTF-8?B?Vm9qdMSbY2ggS2xldGXEjWth?= <vojta.kletecka@gmail.com>
Subject: Re: Data recovery
Date: Thu, 21 Sep 2017 15:22:46 +0200
Message-ID: <CAEmSg08aYMppy6Ardarjz_0P6-HDU8_GCkcOV88g32-T053k_g@mail.gmail.com>
References: <CAEmSg0_=5ni2mA1Q_A1DjZmvjG9u8tKXOQHmnmT33=12yJwYqA@mail.gmail.com>
 <59C309C7.9030300@youngman.org.uk> <796e5efe-04af-60c7-4ef0-f9962e456061@turmel.org>
 <CAEmSg09hzYijYix=gc_Nkbr1Ub4YuDGvP--MpEB8UjB=U71onA@mail.gmail.com> <54c6f639-0912-1f82-41b9-0a778fb5bb89@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54c6f639-0912-1f82-41b9-0a778fb5bb89@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tried both reasonable versions without success:

sudo mdadm --assemble --verbose --force /dev/md127 /dev/sd[ce]1
[sudo] password for vojtech:
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 2.
mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md127
mdadm: added /dev/sdc1 to /dev/md127 as 2 (possibly out of date)
mdadm: added /dev/sde1 to /dev/md127 as 1
mdadm: /dev/md127 assembled from 1 drive - not enough to start the array.

sudo mdadm --assemble --verbose --force /dev/md127 /dev/sd[de]1
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 1.
mdadm: added /dev/sde1 to /dev/md127 as 1
mdadm: no uptodate device for slot 4 of /dev/md127
mdadm: added /dev/sdd1 to /dev/md127 as 0
mdadm: failed to RUN_ARRAY /dev/md127: Input/output error
