From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: strange drive behaviour.
Date: Sun, 06 Mar 2005 18:29:23 +0800
Message-ID: <422ADB83.6070907@fastmail.co.uk>
References: <422AAAA7.6080106@fastmail.co.uk> <1110102091.2033.8.camel@zwerg.variant.ch>
Reply-To: mwaterman@jingmei.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <1110102091.2033.8.camel@zwerg.variant.ch>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nicola Fankhauser wrote:
> hi max
> 
> On Sun, 2005-03-06 at 08:00, Max Waterman wrote:
> 
>>It seems to work as a slave device, but not as a master. I have tried 
>>many combinations of interfaces/cables/power/etc.
> 
> 
> just to check basic things: what are your drives' jumper settings? if
> all your drives are set to "cable select", and the "strange" drive
> explicitely to "slave", then this could explain the behavior. see [1]
> for jumper settings on the WD series.

Unfortunately, all the WD drives are identical and so it's 'impossible' 
to get (just one) wrong; and they're clearly labeled with the jumper 
positions. However, the page at the URL below does show another position 
which isn't on marked on the drive - [4-6] - which is another master 
position. Unfortunately, it didn't make any difference.

The page at the URL below does explain which of the plugs on an EIDE 
cable is master (the black plug on the end) and which is slave (the grey 
plug in the 'middle'), so I was able to try setting it to 'cable select' 
- [1-2] - and try as master and then as slave. Unfortunately, it shows 
the same behaviour - system locks on the initial motherboard flash 
screen (with the fault LED lit) when it is master, and seems to work 
'OK' when set as slave (even though there is no master device[?]).

> 
> 
>>Can I just make it a slave device? How will that effect performance?
> 
> 
> AFAIK there should be only a problem if you have two drives on the same
> bus - they block each other. so it should be fine if you just leave it
> that way...

Hrm. I would be worried about it failing, so I am looking to avoid it in 
that situation in the long term. Since the drives were RAID5, all my 
data is still there (right?), but it'll run degraded (or something) when 
it powers up.

Fortunately, I have 4 other WD2000 drives, but they're SATA. I don't 
think that makes (much) difference; so, I guess I should be able to use 
one of those fairly easily.

What would be the best procedure?

I'm guessing one of these :

1) put the dodgy drive as a slave (with a CDROM as master), and one of 
the SATA drives off the motherboard; use some disk duplicator utility to 
duplicate the contents of the dodgy drive to the SATA drive. Then edit 
the mdadm.conf file to use the SATA drive instead of the dodgy one. RMA 
the dodgy drive.

2) add the SATA drive as a 'spare' and let the md stuff sort itself out.

Any recommendations?

Max.

> 
> though somebody might have a better explanation for the phenomenon...
> 
> regards
> nicola
> 
> [1]:
> http://wdc.custhelp.com/cgi-bin/wdc.cfg/php/enduser/std_adp.php?p_faqid=84&p_created=1005005461
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
