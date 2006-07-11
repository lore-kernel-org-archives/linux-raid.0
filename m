From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: ICH7 sata-ahci + software raid warning
Date: Tue, 11 Jul 2006 14:47:51 +0200
Message-ID: <bb145bd20607110547x5eeab78bh878871308e225129@mail.gmail.com>
References: <bb145bd20607100948y2f41e034re3c0fb30c8bd1ad5@mail.gmail.com>
	 <Pine.LNX.4.64.0607110823160.858@p34.internal.lan>
	 <fd8d0180607110533j7f9fe7c8k7ececea622d7c17b@mail.gmail.com>
	 <Pine.LNX.4.64.0607110839330.858@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0607110839330.858@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> For ICH5 and all other controllers (non-AHCI) of course, I've always seen
> md mark it faulty on a bad disk/sector/etc.

ICH7 (ahci) does not. At least not a whole disk dieing, don't know
about bad sectors.

> I thought you were just trying to mark it faulty manually for the purpose
> of rebuilding it.

Ah, no I wasn't :)

C.
