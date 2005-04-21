From: <peter.greis@ubs.com>
Subject: raid related... or not ?
Date: Thu, 21 Apr 2005 09:46:09 +0200
Message-ID: <6F9171BE257CA742BFBCFA87B8F20F8D030E4524@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I appeal to the larger community...

I am running an ASUS k8ne with a mirrored boot drive, and a 4 disk raid5 array (total of 6). Approximately two weeks ago the raid5 array (reiser -> lvm2 -> raid5) kicked out a drive, which I reinserted (three hour rebuild). Shortly thereafter (this is my server), my clients started having NFS woes. After some head banging, I ran ping from the server to the clients. 80 - 100% packet loss (I note here I am using a Netgear gigabit card).

Nothing in /var/log/messages, nothing special from dmesg. Last night I plugged a laptop into the same drop as the server - ping works perfectly from there to the clients... so cabling doesn't seem to be the issue. Then I pulled the gig card and put a spare 100M card in. Oddly enough, same behavior (now with the link running at 100 instead of 1000). I put the original card back in, but moved it over one slot. Same thing.... Still no messages. No packet collisions with "netstat -i 5" either. At one point (playing with ethtool), I also got nothing back from "ethtool eth0" - which I find very odd. Later, ethtool did return data.

All of this has been tried with both 2.6.8.1 and 2.6.11.7 kernels. At this point I am thinking hardware failure (like the motherboard), but I am looking for opinions. What to try next ? This is crippling my home environment (home directories are shared from here as well as music and video). Also, how are you testing your arrays (are the SMART tools working under raid yet) ?

Any help would be appreciated (the WAF is falling rapidly)

regards,

-Peter

Visit our website at http://www.ubs.com

This message contains confidential information and is intended only 
for the individual named.  If you are not the named addressee you 
should not disseminate, distribute or copy this e-mail.  Please 
notify the sender immediately by e-mail if you have received this 
e-mail by mistake and delete this e-mail from your system.

E-mail transmission cannot be guaranteed to be secure or error-free 
as information could be intercepted, corrupted, lost, destroyed, 
arrive late or incomplete, or contain viruses.  The sender therefore 
does not accept liability for any errors or omissions in the contents 
of this message which arise as a result of e-mail transmission.  If 
verification is required please request a hard-copy version.  This 
message is provided for informational purposes and should not be 
construed as a solicitation or offer to buy or sell any securities or 
related financial instruments.

