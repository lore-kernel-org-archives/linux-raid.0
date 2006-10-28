From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Propose of enhancement of raid1 driver
Date: Sat, 28 Oct 2006 22:30:48 +0200
Message-ID: <ei0elo$23m$1@sea.gmane.org>
References: <45347D6E.3000600@mieszczak.com.pl> <17718.61672.794099.425723@cse.unsw.edu.au> <ehin29$80g$1@sea.gmane.org> <200610282031.07893.a1426z@gawab.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Al Boldi <a1426z@gawab.com> wrote:
> But what still isn't clear, why can't raid1 use something like the raid10 
> offset=2 mode?

RAID1 has equal data on all mirrors, so sooner or later you have to seek
somewhere - no matter how you layout the data on each mirror.


regards
   Mario
-- 
Programmieren in C++ haelt die grauen Zellen am Leben. Es schaerft
alle fuenf Sinne: den Schwachsinn, den Bloedsinn, den Wahnsinn, den
Unsinn und den Stumpfsinn.
                                 [Holger Veit in doc]

