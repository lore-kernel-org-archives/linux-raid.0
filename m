From: David Rees <drees76@gmail.com>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Thu, 30 Jul 2009 13:28:42 -0700
Message-ID: <72dbd3150907301328r321cefdejd74d143db4494c13@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com>
	<20090730183526.GD19663@tracyreed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090730183526.GD19663@tracyreed.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tracy Reed <treed@ultraviolet.org>
Cc: Tirumala Reddy Marri <tmarri@amcc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 30, 2009 at 11:35 AM, Tracy Reed<treed@ultraviolet.org> wro=
te:
> On Wed, Jul 29, 2009 at 11:25:47PM -0700, Tirumala Reddy Marri spake =
thusly:
>> =A0 I have two 1 tera byte disks in RAID-1 configuration. When I sta=
rted
>> RAID-1 array initial speed was 100MBps by the time it finishes the s=
peed
>> was <50MBps. Is there is any reason for this behavior ? Isn't speed
>> supposedly uniform.
>
> I currently have a RAID-1 rebuild running and cat /proc/mdstat shows
> speed=3D1481K/sec. This seems incredibly slow to me. That's just just
> about one and a half megs per second. I'm wondering if this machine
> has some more serious hardware problem. No errors showing up in dmesg
> or /var/log/messages or anything though.

If there is any read/write activity on the array, resync speeds will
slow down significantly as it tries to minimize the effect on system
performance by default.  You can try upping the min sync speed through
/proc to increase the sync speed, but array performance will suffer
more.

-Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
