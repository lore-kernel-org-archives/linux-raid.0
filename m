From: <peter.greis@ubs.com>
Subject: Odd behavior on add...
Date: Wed, 4 May 2005 10:48:01 +0200
Message-ID: <6F9171BE257CA742BFBCFA87B8F20F8D030E45CE@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I just had a SATA drive fail (in a raid 5 array) which I replaced. The boot message gave me "invalid partition table", so I fired up fdisk and created a primary parition on type "fd". Then I put the drive in the array with "mdadm /dev/md3 --add /dev/sda", which seemed to go OK (rebuild took three hours). The array did start degraded, and the lvm volumes on top of that mounted with no issues.

Now the odd part - on a reboot, I once again get "invalid parition". After writing the parition table and rebuilding, mdadm --detail --scan shows the replaced device as (from memory) /dev/evms/.sda<someotherbits>. This is very odd... I am using lvm2, not evms. Thoughts ? Is there something I am missing when reinserting the drive ?

Thanks to all in advance,

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

