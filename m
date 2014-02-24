From: wiebittewas <wiebittewas@googlemail.com>
Subject: Re: Data Offset
Date: Mon, 24 Feb 2014 12:22:44 +0100
Message-ID: <530B2B84.3010208@gmail.com>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com> <20120602095237.3822e2c2@notabene.brown> <CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com> <20120604133526.6da3bf10@notabene.brown> <4FCCFDBB.201@pierre-beck.de> <20120605085728.7e922359@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120605085728.7e922359@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 05.06.2012 00:57 schrieb "NeilBrown" bzgl. "Re: Data Offset":


> OK, try:
> 
>    git clone -b data_offset git://neil.brown.name/mdadm
>    cd mdadm
>    make
> 
>    ./mdadm -C /dev/md1 -e 1.2 -l 5 -n 5 --assume-clean -c 512 \ 
>       /dev/sdc3:2048s /dev/sdb3:2048s ???  /dev/sdd3:1024s ???
> 
> The number after ':' after a device name is a data offset.  's' means sectors.

well, luckily I've found this message and was able to rescue an array
with two failed disks with only a few damaged files...

but is there any possibility that this features comes into normal tree,
so it will be usable in near future from rescue-sticks like grml?

> Don't install this mdadm, and don't use it for anything other than
> re-creating this array.

or does it interfere with other necessary features?

I've viewed a diff to standard 3.2.5 and doesn't see real complex
things, but even a lot of smaller changes.

at least thanks for your work.

w.


