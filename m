From: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Subject: Re: Linux RAID autodetect partitions go missing from /dev, but fdisk can see them
Date: Mon, 19 Jan 2009 17:18:57 +0100
Message-ID: <4974A7F1.1000107@gmail.com>
References: <49402CFE.3080708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49736C2A.3050108@gmail.com>
References: <18759.8246.568849.244513@notabene.brown>
References: <494AC8BA.7010704@gmail.com>
References: <18762.53424.819087.495066@notabene.brown>
References: <49736C2A.3050108@gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tor Arne Vestb=F8 wrote:
> So is this a case of the problem you described about
> superblock-confusion? If so, is it fixable?

Btw, I cloned mdadm from your site, so I have an updated version now. I
haven't installed it yet, in case it can damage the existing RAID, but
if there are any tests I can run with the updated version I'm ready for
them :)

Tor Arne
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
