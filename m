From: Christian Pernegger <pernegger@gmail.com>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 15:43:42 +0200
Message-ID: <bb145bd20909170643r48567477i400eab5052737070@mail.gmail.com>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'm looking for a reliable and inexpensive 4port PCI controller.

Short version: There aren't any, fakeraid is all the rage now :-(

Longer version: I have two Dawicontrol DC-4320 RAIDs (sata_sil24),
whose fakeraid BIOS can be disabled via jumper. They work great, but
they were ~=E2=82=AC100 apiece IIRC and they are PCI-X not regular PCI.=
 Should
be backwards-compatible but you never know.

Cheers,

C.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
