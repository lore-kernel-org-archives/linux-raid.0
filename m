From: Niobos <niobos@dest-unreach.be>
Subject: List of mismatched blocks?
Date: Sat, 03 Jul 2010 19:15:33 +0200
Message-ID: <i0nr7l$jge$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Weekly, I'm checking my RAID1 array using:
echo "check" >> /sys/block/$MD/md/sync_action

Every few weeks, I get a mismatch count (which are easily solved with a
"sync"). Is there an easy way to get a list of blocknumbers that
mismatch? I'd like to figure out what may be causing this mismatch.

Regards,
Niobos

