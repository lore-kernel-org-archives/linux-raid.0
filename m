From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: suns raid-z / zfs
Date: Thu, 21 Feb 2008 11:37:08 +0100
Message-ID: <fpjk8k$k67$1@ger.gmane.org>
References: <20080217160403.GA15710@rap.rap.dk> <18361.1168.473685.214133@notabene.brown> <20080218053319.GA18863@rap.rap.dk> <18361.25379.998485.63488@notabene.brown> <20080218204529.GA17984@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen <keld@dkuug.dk> wrote:
> On Mon, Feb 18, 2008 at 09:51:15PM +1100, Neil Brown wrote:
>> Recovery after a failed drive would not be an easy operation, and I
>> cannot imagine it being even close to the raw speed of the device.
> I thought this was a problem with most raid types, while
> reconstructioning, performance is quite slow. And as there has been s=
ome

There is a difference between "recovery is quite slow" and "raid device
access is quite slow" The former is an issue since it stretches the tim=
e
where you're in non-redundant danger while the latter is just
inconvenient.


regards
   Mario
--=20
I heard, if you play a NT-CD backwards, you get satanic messages...
That's nothing. If you play it forwards, it installs NT.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
