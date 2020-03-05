From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Need help with degraded raid 5
Date: Thu, 5 Mar 2020 17:22:20 +0000
Message-ID: <5E61354C.2090901@youngman.org.uk>
References: <CALc6PW74+m1tk4BGgyQRCcx1cU5W=DKWL1mq7EpriW6s=JajVg@mail.gmail.com>
 <CAD9gYJ+3gP+6aannsjzq=L0DsQ-dC2wj4SJfU3+n-t3pG0q3pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAD9gYJ+3gP+6aannsjzq=L0DsQ-dC2wj4SJfU3+n-t3pG0q3pg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpuwang@gmail.com>, William Morgan <therealbrewer@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/03/20 14:53, Jinpu Wang wrote:
> "mdadm /dev/md0 -a /dev/sdl1"  should work for you to add the disk
> back to array, maybe you can check first with "mdadm -E /dev/sdl1" to
> make sure.

Or better, --re-add or whatever the option is. If it can find the
relevant data in the superblock, like bitmap or journal or whatever, it
will just bring the disk up-to-date. If it can't, it functions just like
add, so you've lost nothing but might gain a lot.

Cheers,
Wol
