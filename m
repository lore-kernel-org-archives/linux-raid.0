From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: Kernel preventing (extra) spare disk in array from entering standby
Date: Wed, 25 Oct 2017 11:28:40 +0200
Message-ID: <CAJO99Tn=1TRahO1gH4KW-8=g4rdf4PaCbPMbR3a6Ui1c_i3QuQ@mail.gmail.com>
References: <CAJO99TkXsobN3EszoPM37y=Eth-URQeLTSd8fBDpATHg1x-tmQ@mail.gmail.com>
 <f656c779-f376-82a2-cf2f-769767b478d6@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f656c779-f376-82a2-cf2f-769767b478d6@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Oct 24, 2017 20:31, "Phil Turmel" <philip@turmel.org> wrote:
>
> That sounds like writes to the write-intent bitmap, which happens to all
> devices in an array while degraded.
>
> Why do you have 12 spares attached to the array?  That seems a bit
> excessive.

This is a 60 disk array, and the only reason for having 12 disks as spares
(could be any number, really) is the frequency of visiting datacenter.

There are multiple arrays, and these spares are moved as they are needed,
but as far as I can tell, it is not easy if at all possible to
distribute slaves evenly
among arrays when using udev rules and --incremental to add them.

--
Bj=C3=B8rnar
