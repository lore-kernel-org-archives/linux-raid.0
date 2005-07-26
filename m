From: "J. Ali Harlow" <ali@juiblex.co.uk>
Subject: Re: Can't work out how to recover after multiple failures
Date: Tue, 26 Jul 2005 09:51:47 +0100
Message-ID: <1122367907.1184.239244752@webmail.messagingengine.com>
References: <1122222141.13200.239118760@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1122222141.13200.239118760@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sun, 24 Jul 2005 17:22:21 +0100, "J. Ali Harlow" <ali@juiblex.co.uk>
said:
> Can anyone please help me get my raid 1 device back up and running? I
> had a chipset failure which took out one disk and then just after
> replacing the disk and resyncing, the original disk lost power due to=
 a
> loose connection. mdadm seems to think that both devices are fine, bu=
t I
> can't seem to fine the magic vodoo to get the raid array working agai=
n.
> Sorry if this is a really stupid question. I did read the documentati=
on
> for mdadm pretty carefully, but I'm obviously missing something. Many
> thanks,

=46inally got this working. There seem to have been two issues. First,
mdadm didn't like running an array as a seperate step to assembling it.
(mdadm -R /dev/md0 was giving me "Invalid Argument"). Doing this in one
step however did work. Secondly, I suspect the two devices weren't
synced even though mdadm -E wasn't showing this which was casuing
attempts to assemble an array containing both devices to quietly fail.
The final sequence which worked was:

reboot
mdadm --assemble /dev/md0 --run /dev/hda2
mdadm /dev/md0 -a /dev/hde2

Easy when you know :-)

Ali.

--=20
http://www.fastmail.fm - Same, same, but different=85

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
