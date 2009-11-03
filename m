From: Jesse Wheeler <jwwstpete@gmail.com>
Subject: Re: Random MD Raid resyncs?
Date: Tue, 3 Nov 2009 09:44:50 -0500
Message-ID: <f1ef83020911030644j140c1cfft81540ddd769a46f7@mail.gmail.com>
References: <f1ef83020911020655kf8935c5icf9aea31edb03c57@mail.gmail.com>
	 <f1ef83020911020657w1494e31ao716203f9fb9f0d8f@mail.gmail.com>
	 <155cc2abd59adbec8b109a0602d7431d.squirrel@neil.brown.name>
	 <f1ef83020911021540i4094fa1dqc87a6ff0b5b675f0@mail.gmail.com>
	 <20091103100528.GG24791@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091103100528.GG24791@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Gabor:

> auto-read-only is an internal state of the RAID array, it has nothing=
 to
> do with file systems. So you probably won't find anything in the
> locations you mention above; auto-read-only is only displayed in
> /proc/mdstat. Look at the mdadm man page and read the sections "Auto
> Assembly" and "INCREMENTAL MODE".

Interesting.  I just got done reading that section in the manpage; if
anything, I didn't know mdadm would process an array in that fashion.
However, I don't see this behavior listed in my /proc/mdstat output.
If it's there, I'm missing it:

-- SNIP --

# cat /proc/mdstat
Personalities : [raid10] [raid6] [raid5] [raid4]
md1 : active raid5 sda2[0] sdb1[1] sdc1[2] sdd1[3] sde1[4] sdf1[5]
      393230080 blocks level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]

md2 : active raid5 sda4[0] sdb4[1] sdc3[2] sdd3[3] sde3[4] sdf4[5]
      424034560 blocks level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]

md0 : active raid10 sdf2[5] sde2[4] sdd2[3] sdc2[2] sdb2[1] sda3[0]
      235938048 blocks 256K chunks 2 near-copies [6/6] [UUUUUU]

unused devices: <none>

-- END SNIP --

On Tue, Nov 3, 2009 at 5:05 AM, Gabor Gombas <gombasg@sztaki.hu> wrote:
> On Mon, Nov 02, 2009 at 06:40:59PM -0500, Jesse Wheeler wrote:
>
>> AFAIK, any of the RAID devices are not mounted 'auto-read-only' by t=
he
>> kernel. =A0I'll double check /etc/fstab, /var/log/messages, and
>> /var/log/dmesg when I get back to the site. =A0Unless there was a ch=
ange
>> by the upstream vendor, I wouldn't mount a production filesystem in
>> that manner. =A0Of course, I've been surprised before!
>
> auto-read-only is an internal state of the RAID array, it has nothing=
 to
> do with file systems. So you probably won't find anything in the
> locations you mention above; auto-read-only is only displayed in
> /proc/mdstat. Look at the mdadm man page and read the sections "Auto
> Assembly" and "INCREMENTAL MODE".
>
> Gabor
>
> --
> =A0 =A0 ---------------------------------------------------------
> =A0 =A0 MTA SZTAKI Computer and Automation Research Institute
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Hungarian Academy of Sciences
> =A0 =A0 ---------------------------------------------------------
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
