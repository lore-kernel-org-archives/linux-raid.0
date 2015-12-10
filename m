From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Thu, 10 Dec 2015 22:23:29 +0000
Message-ID: <5669FB61.3020207@youngman.org.uk>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
 <22121.38606.101474.41382@quad.stoffel.home>
 <CAE9DZUTO-Muvgp+ofAkoKD1KcunnZ821UeSJch4216iWYL61cQ@mail.gmail.com>
 <22121.53825.857640.201383@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22121.53825.857640.201383@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>, Dallas Clement <dallas.a.clement@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/12/15 19:28, John Stoffel wrote:
> At this point, you need to now look at your controllers and
> motherboard and how they're configured.  If all those drives are on
> one controller, and if that controller is on a single lane of PCIe,
> then you will see controller bandwidth issues as well.

Very out of date ... we're talking the days of CD writers here ... but
we used a pc to write bulk CDs, and we found we simply had to buy add-in
IDE cards to get decent performance - two CD drives on the same PATA
cable and response went through the floor - massively so.

Cheers,
Wol
