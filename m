From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID1 array losing one member
Date: Wed, 4 Nov 2009 11:57:39 -0800
Message-ID: <4877c76c0911041157t49bfeccaq65bb41398be77667@mail.gmail.com>
References: <20091104161801.GC20938@shuttle.verdurin.salon>
	 <ABFC24E4C13D81489F7F624E14891C865AA4CA39@uk-ex-mbx1.terastack.bluearc.com>
	 <20091104175507.GD20938@shuttle.verdurin.salon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091104175507.GD20938@shuttle.verdurin.salon>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Huffman <bloch@verdurin.com>
Cc: Simon Jackson <sjackson@bluearc.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It looks like this could be a failing disk, however to be sure you
might want to replace the SATA cable with a new latching one and then
run the usual SMART tests via smartctl.
