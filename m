From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Flappy hotswap disks?
Date: Tue, 25 Oct 2005 11:28:52 +0200
Message-ID: <djktsk$72u$1@sea.gmane.org>
References: <62b0912f0510250137n6ba372c5x312174d908247437@mail.gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich <molle.bestefich@gmail.com> wrote:
> Eg. will it increase the event counters on the other disks /even/ when
> no reboot or stop-start has been performed, so that when the flappy

Event counters are increased immediately when an event occurs.
A device failure is an event as well as start and stop of a RAID are.


regards
   Mario
-- 
Programmieren in C++ haelt die grauen Zellen am Leben. Es schaerft
alle fuenf Sinne: den Schwachsinn, den Bloedsinn, den Wahnsinn, den
Unsinn und den Stumpfsinn.
                                 [Holger Veit in doc]

