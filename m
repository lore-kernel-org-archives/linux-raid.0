From: "Potthoff, Kay" <Kay.Potthoff@force.de>
Subject: Q: Priority of md_thread()
Date: Wed, 22 May 2002 13:59:57 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <9CFB9DA5261CD611A29B00508B789048654302@ex-deu-munich02.force.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Linux RAID Mailing List (E-mail)" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a question regarding the priority of the md_thread() function
(defined in md.c).

I have seen that the priority of this thread is set to -20 (parameter
current->nice), which means that this thread takes the highest priority=
=2E The
problem I have is that this thread blocks some other task that is answe=
ring
keep alive network pings from another (sibling) node. Because the keep =
alive
answers are blocked the other node decides to take-over the RAID. This
situation leeds to the fact that two nodes try to start the RAID. MD do=
n't
like this. The RAID is considered to be faulty and both nodes try to re=
pair
it, that is a problem.

I figuered out that the cause of this problem is the high priority of t=
he
md_thread() function. I feel tempted to decrease this priority, but I f=
eel
some upcoming ache in my belly because I don't know the exact reason wh=
y the
priority had been set to -20. I hope that somebody can explain me why! =
The
comments in the sources seem to regard to RAID-5 personality. If so tha=
t
would be no problem, I intend only to use RAID-1.

Thanks in advance, Kay

######################################################
# Kay Potthoff              Senior Software Engineer
#
# FORCE Computers GmbH        Tel.: +49-89-60814-356
# Prof.-Messerschmitt-Str. 1    FAX : +49-89-6097793
# 85579 Neubiberg/M=FCnchen
# Deutschland/Germany
#
# mailto:Kay.Potthoff@force.de
######################################################
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
