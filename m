From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Posting on RISKS - hacked NAS's
Date: Mon, 26 Sep 2016 09:40:47 +1000
Message-ID: <de6e2183-1e89-2495-1546-e71bf4bc27e9@websitemanagers.com.au>
References: <57E842C7.9000302@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E842C7.9000302@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I strongly suspect that this article is talking about a NAS (Network 
Attached Storage), or as described a mini-computer with hard drives 
attached and open to the network, this is not about firmware on drives 
that you would connect to your own Linux computer.

Questions about the accuracy of the article:
1) Seagate has only sold 7000 of this product? Seems like a very small 
run for a major manufacturer...
2) 70% have been hacked? Did the hacker themselves reveal this, or did 
Seagate, or how does this source know?

I would strongly suspect a much higher number of devices sold, and would 
strongly suspect that almost all of these devices would sit behind a 
simple NAT router. Unless seagate have done something really stupid 
(like using upnp to ask the router to port forward from outside directly 
to it *by default*), then this should provide a reasonably decent level 
of protection.

PS, Not to say that the article probably is very accurate, you should 
change passwords, you should have backups, you should NOT allow direct 
connections to your backend storage, etc....

Nevermind, reading deaper:
http://www.infoworld.com/article/3118792/malware/thousands-of-seagate-nas-boxes-host-cryptocurrency-mining-malware.html
We see that they looked for all open FTP servers with public writeable 
directories (7,263) and of those a large majority were Seagate NAS 
(5137). So, Seagate almost certainly have sold more than 7000 of their 
NAS, 7000 has absolutely no correlation to the number of Seagate NAS 
sold or connected.

Of further note:
"Seagate Central's configuration makes it easier for users to expose 
insecure FTP servers to the Internet"
"By default, the Seagate Central NAS system provides a public folder for 
sharing data, ... This public folder cannot be disabled and if the 
device administrator enables remote access to the device, it will become 
accessible to anyone on the Internet"

Finally, the "infection" is just placing the files there, and then 
waiting for the user to execute them on their windows PC, it is not a 
remote code execution exploit by itself.

Regards,
Adam

On 26/09/16 07:33, Wols Lists wrote:
> Just for info. I know it's not really quite this list, but I can't quite
> make out what is affected.
>
> I get the impression this is referring to NAS systems, so it's outside
> our remit. But to me, "Seagate NAS" is actually a raid-suitable disk
> drive, so it makes me wonder whether it's hacked drive firmware...
> unlikely but eminently possible ...
>
> Cheers,
> Wol
>
> ------------------------------
>
> Date: Fri, 23 Sep 2016 11:34:21 -0700
> From: Gene Wirchenko <genew@telus.net>
> Subject: "Seagate NAS hack should scare us all" (Roger A. Grimes)
>
> Roger A. Grimes, InfoWorld, 20 Sep 2016
> An under-the-radar news story proves that computers are far from the only
> devices prey to attack
> http://www.infoworld.com/article/3121338/security/seagate-nas-hack-should-scare-us-all.html
>
> opening text:
>
> No fewer than 70 percent of Internet-connected Seagate NAS hard drives have
> been compromised by a single malware program. That's a pretty startling
> figure.  Security vendor Sophos says the bitcoin-mining malware Miner-C is
> the culprit.
>
>    [At peak, seek to tweak the weak link.  This reeks of leaks that peek as
>    well.  PGN]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
