From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RFC - new raid superblock layout for md driver
Date: 20 Nov 2002 14:09:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1037801381.3267.17.camel@irongate.swansea.linux.org.uk>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2002-11-20 at 04:09, Neil Brown wrote:
>     u32  set_uuid[4]

Wouldnt u8 for the uuid avoid a lot of endian mess

>     u32  ctime

Use some padding so you can go to 64bit times
