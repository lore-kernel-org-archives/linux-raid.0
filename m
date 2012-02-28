From: Jon Hardcastle <Jon@ehardcastle.com>
Subject: 3 Drives down, Help!
Date: Tue, 28 Feb 2012 16:34:18 +0000
Message-ID: <CAOqmSEnYKkRT6O2NyVUXZDhurxOGUOZ+0GLx6OjuxmZd1di6Ag@mail.gmail.com>
References: <CAOqmSEkenu54inSwVerefb_pcZ3bmSHrjDa2YX7ynuDWi-jRuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOqmSEkenu54inSwVerefb_pcZ3bmSHrjDa2YX7ynuDWi-jRuw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

I have been battling with=A0intermittent=A0drive drop outs that I have
been steadily pointing the finger of blame at the power supply; it is
old and is 450w powering 9 hard drives.

Unfortunately now I have been hit by a perfect storm of 3 of the 7
drives (raid 6) have been booted..

I am wonder what the best way to proceed is.. I want to

i) stop the array from auto assembling just in case one of the other
drive randomly 'fails' due to PSU or cabling issue.
ii) install a new power supply and check all cabling.
iii) Thrash the drives individually
iv) Assemble the array (read only?) so that any kickouts I can
confidence force the assemble
v) Adding the failed drives back in 1 of a time, presumably this is
better than adding multiple drives at the same time?

Any tips and pointers would be fantastic.

Thanks.

--
----------
N: Jon Hardcastle
E: Jon@eHardcastle.com
Q: The avalanche has already started. It is too late for the pebbles to=
 vote.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
