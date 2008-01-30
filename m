From: "Michael Mott" <michael.mott@gmx.net>
Subject: Check mdadm-Raid 5
Date: Wed, 30 Jan 2008 10:07:44 +0100
Message-ID: <20080130090744.249790@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

you're just my last hope - I think.

I've posted this question at many Web-Sites in the last week, but nobody can help me.

For a view days I've created a Software Raid 5 (mdadm) under Ubuntu 7.10 32Bit Alternate with 4 x 233 GiB SATA II Hdds @ USB 2.0.

After that I want to create a Truecrypt-Volume on this md-Device what not should be a problem.

But the Process hangs after a view Minutes running and then whole System hangs. So I've pushed the Power-Button and the System writes something to the System-Hdd - but then nothing happens further. Then I have resetted the System.

After next boot I've assembled the Raid 5 again what function without any problem. The System even wont to resync anything.

After that I've build the Truecrypt-Volume on the whole md-Device without any Problem. 

Now my question: Is there any Methode to Test the integrity of die md-Device at low-level? Can I trust the Device?

Best regards,

Michael
-- 
GMX FreeMail: 1 GB Postfach, 5 E-Mail-Adressen, 10 Free SMS.
Alle Infos und kostenlose Anmeldung: http://www.gmx.net/de/go/freemail
