From: "Nigel J. Terry" <nigel@nigelterry.net>
Subject: Re: Raid5 reshape (Solved)
Date: Sat, 24 Jun 2006 18:58:59 -0400
Message-ID: <449DC3B3.2050307@nigelterry.net>
References: <449250ED.7090302@irule.net>	<17554.21119.487820.638171@cse.unsw.edu.au>	<4492D5B1.60004@nigelterry.net>	<4492D8D9.7010101@irule.net>	<17555.12441.42212.93049@cse.unsw.edu.au>	<4493330E.30501@nigelterry.net>	<17555.13409.834439.80361@cse.unsw.edu.au>	<44945643.3070300@nigelterry.net>	<17556.31295.280083.533342@cse.unsw.edu.au>	<44947BCA.9040305@nigelterry.net>	<44947C98.6060809@nigelterry.net>	<17556.32630.611922.294047@cse.unsw.edu.au>	<44948002.3050706@nigelterry.net>	<44954DB7.2000305@nigelterry.net>	<17558.1521.522659.91428@cse.unsw.edu.au>	<44971A51.6050008@nigelterry.net>	<17559.10564.840472.525999@cse.unsw.edu.au>	<44972AF1.8040500@nigelterry.net>	<17559.13371.751956.423312@cse.unsw.edu.au>	<449734AE.10907@nigelterry.net>	<4497CF71.5050906@nigelterry.net> <17560.57599.658968.66555@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17560.57599.658968.66555@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil

Well I did warn you that I was an idiot... :-) I have been attempting to
work out exactly what I did and what happened. All I have learned is
that I need to keep better notes

Yes, the 21 mounts is a fsck, nothing to do with raid. However it is
still noteworthy that this took several hours to complete with the raid
also reshaping rather than the few minutes I have seen in the past. Some
kind of interaction there.

I think that the kernel I was using had both the fixes you had sent me
in it, but I honestly can't be sure - Sorry. In the past, that bug
caused it to fail immediately and the reshape to freeze. This appeared
to occur after the reshape, maybe a problem at the end of the reshape
process. Probably however I screwed up, and I have no way to retest.

Finally, just a note to say that the system continues to work just fine
and I am really impressed. Thanks again

Nigel

