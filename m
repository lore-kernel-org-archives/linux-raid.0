From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Software raid - controller options
Date: Wed, 07 Nov 2007 10:51:10 +0100
Message-ID: <873avijsdt.fsf@informatik.uni-tuebingen.de>
References: <1194315635.17361.20.camel@localhost.localdomain>
	<472FD6A4.5030907@sauce.co.nz>
	<1194319214.17361.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194319214.17361.36.camel@localhost.localdomain> (Lyle
	Schlueter's message of "Tue, 06 Nov 2007 06:20:14 +0300")
Sender: linux-raid-owner@vger.kernel.org
To: Lyle Schlueter <lyle@xkubed.com>
Cc: Richard Scobie <richard@sauce.co.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lyle Schlueter <lyle@xkubed.com> writes:

> Do you know of any concerns of using all the ports on a motherboard?
> Slowdowns or anything like that?

More likely the opposite. But it depends on how the chips are
connected.

On desktop boards the onboard chip is in the north and/or southbridge
and has a better connect to the ram than the addon controlers can ever
hope for. On server boards the situation is likely the same.

MfG
        Goswin
