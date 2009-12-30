From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: raid0/jbod/lvm, sorta?
Date: Wed, 30 Dec 2009 10:31:38 +0100
Message-ID: <4B3B1DFA.3090308@computer.org>
References: <20091230000357.GA23485@septictank.raw-sewage.fake> <alpine.DEB.1.10.0912300712090.27231@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0912300712090.27231@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Matt Garman <matthew.garman@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> Unionfs will do this for you.

The requirements stated "few writes", not "no writes".

Correct me if I'm wrong, but I think that unionfs only allows writes to the highest-precedence branch. So writes to the store would all end up on one disk.

Jan
