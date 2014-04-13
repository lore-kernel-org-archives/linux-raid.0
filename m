From: Drew <drew.kay@gmail.com>
Subject: Re: Nvidia Raid5 Failure
Date: Sun, 13 Apr 2014 09:42:19 -0700
Message-ID: <CACJz6QtoddN1nOcfzeJeV-09j+t9fhT=E2a17Ppxq4gXpZDcVA@mail.gmail.com>
References: <DUB122-W521994A2683B8CBD327D3DA3550@phx.gbl> <CAK_KU4ZHZik=_=2=fMPW1c_y-xc0DW_9=ucsYQXU2e=eSOtYQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4ZHZik=_=2=fMPW1c_y-xc0DW_9=ucsYQXU2e=eSOtYQg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 10, 2014 at 7:36 AM, Scott D'Vileskis <sdvileskis@gmail.com> wrote:
> <snip>  I
> would also advise against what is known as 'fake raid' controllers
> like your NVIDIA hardware likely is, (or Promise, highpoint, Intel,
> etc)  because it can be difficult to recover data if you have a
> controller/mobo failure without exact hardware.

Agree on the staying away from fake-RAID. One thing I will point out
for reference tho, is that not *all* Intel RAID is fakeraid. The
onboard RAID built into Intel's ICH family certainly is. However Intel
does make a line of RAID controller daughter cards which are rebadged
LSI RAID controllers and are in fact true H/W RAID. Easiest way to
know is to see if the card supports SAS. If it does, chances are it's
a H/W RAID card.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
