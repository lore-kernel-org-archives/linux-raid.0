From: Nicola Fankhauser <nicola.fankhauser@variant.ch>
Subject: Re: strangre drive behaviour.
Date: Sun, 06 Mar 2005 10:41:31 +0100
Message-ID: <1110102091.2033.8.camel@zwerg.variant.ch>
References: <422AAAA7.6080106@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <422AAAA7.6080106@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi max

On Sun, 2005-03-06 at 08:00, Max Waterman wrote:
> It seems to work as a slave device, but not as a master. I have tried 
> many combinations of interfaces/cables/power/etc.

just to check basic things: what are your drives' jumper settings? if
all your drives are set to "cable select", and the "strange" drive
explicitely to "slave", then this could explain the behavior. see [1]
for jumper settings on the WD series.

> Can I just make it a slave device? How will that effect performance?

AFAIK there should be only a problem if you have two drives on the same
bus - they block each other. so it should be fine if you just leave it
that way...

though somebody might have a better explanation for the phenomenon...

regards
nicola

[1]:
http://wdc.custhelp.com/cgi-bin/wdc.cfg/php/enduser/std_adp.php?p_faqid=84&p_created=1005005461

