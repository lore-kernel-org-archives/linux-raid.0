From: Henry Golas <Henry.Golas@argonaut.ca>
Subject: Failed RAID5 & recovery advise
Date: Tue, 17 Jun 2014 09:19:14 -0400
Message-ID: <53A04052.70905@argonaut.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Henry.golas@argonaut.ca
List-Id: linux-raid.ids

Hello All,

Checking to see if this mailing list is still active.

I've got a RAID5 (3+1) array that has failed two drives (yes I know that 
is bad). I wanted to see what recovery advise is out there.

My action plan was to:

1) run mdadm --examine /dev/sd[whatever] >> raidoutput.txt
2) run manufacture disk diagnostic tools to see if the disks have really 
failed
3) attempt to for assembly of the RAID
4) if unsuccessful, go from there.

Running mdadm version v3.2.2

Any insight / advise would be much appreciated,

Thanks,

Hg
