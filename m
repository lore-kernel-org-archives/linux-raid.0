From: Phil Turmel <philip@turmel.org>
Subject: Re: Data recovery
Date: Thu, 21 Sep 2017 09:13:55 -0400
Message-ID: <54c6f639-0912-1f82-41b9-0a778fb5bb89@turmel.org>
References: <CAEmSg0_=5ni2mA1Q_A1DjZmvjG9u8tKXOQHmnmT33=12yJwYqA@mail.gmail.com>
 <59C309C7.9030300@youngman.org.uk>
 <796e5efe-04af-60c7-4ef0-f9962e456061@turmel.org>
 <CAEmSg09hzYijYix=gc_Nkbr1Ub4YuDGvP--MpEB8UjB=U71onA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEmSg09hzYijYix=gc_Nkbr1Ub4YuDGvP--MpEB8UjB=U71onA@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?Vm9qdMSbY2ggS2xldGXEjWth?= <vojta.kletecka@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/21/2017 08:55 AM, Vojtěch Kletečka wrote:
> Requested command outputs are at the end of the mail and verbose
> version of mdadm assembly yielded nothing new as I have already tried
> --force and/or --run for assembling. For the sake of completeness I
> also provide versions of mdadm and kernel.

One of your devices is failing on superblock write.  You cannot save it,
at least not with that USB interface.  Leave it out of your assemble
command. Use --force.

mdadm --assemble --verbose --force /dev/md127 /dev/sd[ce]1

{Adjust if device letters change.}

Report what it prints.  If it works, immediately back up what you need
(there won't be a rebuild).

After you recover any critical data, blow away and reconstruct the
entire array using proper SATA ports.

Include in your system's boot scripts the following:

for x in /sys/block/sd[whatever]/device/timeout ; do echo 180 > $x ; done

Phil
