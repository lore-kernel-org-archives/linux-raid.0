From: Valentijn Sessink <v@lentijn.sess.ink>
Subject: Re: mdadm RAID6 "active" with spares and failed disks; need help
Date: Mon, 12 Jan 2015 00:22:26 +0100
Message-ID: <54B305B2.6000702@lentijn.sess.ink>
References: <54ABEE54.6020707@sympatico.ca> <BLU436-SMTP156F9ECC68035EAC3DFB5F181460@phx.gbl> <BLU437-SMTP96782B2C74C634FDED13D681420@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU437-SMTP96782B2C74C634FDED13D681420@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Callaghan <matt_callaghan@sympatico.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Matt,

I'm by no means a specialist, but I have been saving a few arrays
lately, so here's my 2 cents. From what I see, I'd say you're almost
there, but you didn't use "--bitmap=3Dnone" in your create-statement an=
d
as far as I can see, there is no bitmap specified in the original raid
blocks but there is one in the newly created one. I may be wrong
though!, please take my advice with a grain of salt and at your own ris=
k.

Also, I would not have dared to run all these statements on "live" (or
dead, for that matter ;-) disks. See my posting (that is unfinished, bu=
t
I'll add info as I have time) at
http://valentijn.sessink.nl/?p=3D557 where I use "dmsetup" to create a =
few
virtual disks - all writes are redirected to another device. Fun thing
is, that after that, you can mess up all you want. You just remove the
virtual disk and poof, everything is as it was before (failed raid and
all, isn't that funny? :)

I hope this helps.

Best regards,

Valentijn

On 11-01-15 21:26, Matt Callaghan wrote:
> Updating this e-mail thread. I got the latest mdadm version that
> supports data offset variance per device and attempted to reconstruct
> RAID6 according to previous data, but so far no luck.
> As far as I a can tell (sadly), all of my data is lost. I've updated =
the
> forum thread with the final details and failures.
> http://www.linuxquestions.org/questions/linux-server-73/mdadm-raid6-a=
ctive-with-spares-and-failed-disks%3B-need-help-4175530127/

--=20
=E2=9C=89 v@lentijn.sess.ink =E2=98=8F +31777777713 (31 7x7 13)
=E2=8C=82 durgerdamstraat 29 zaandam
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
