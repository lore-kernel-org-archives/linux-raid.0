From: Phil Turmel <philip@turmel.org>
Subject: Re: start dm-multipath before mdadm raid
Date: Thu, 10 Dec 2015 11:55:56 -0500
Message-ID: <5669AE9C.7040904@turmel.org>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Remek" <p.remek1@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/10/2015 10:29 AM, P. Remek wrote:
> Hello,
> 
> I am trying to create mdadm raid on top of dm-multipath devices.
> Everything works but after reboot the mdadm array is assembled from
> the original (not multipath devices) devices and the multipath devices
> are not created at all.
> 
> Aparently it is because the mdadm software raid is started before the
> dm-multipath creates the multipathed devices. Is there a way how to
> make the dm-multipath start before the mdadm is started?

Order of device discovery is not guaranteed, but base devices will
almost always show up before multipath devices.  You have to filter out
the base devices from mdadm consideration:

Add a DEVICES statement to your mdadm.conf that only matches your
multipath device names, not the base names.  Then update your initramfs
so it applies to early boot as well.

Phil

