From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: md Grow for Raid 5
Date: Tue, 08 Mar 2005 20:34:56 +0100
Message-ID: <422DFE60.5020807@weisshuhn.de>
References: <676e074ffe5f52e6671aac5a2c14e984@case.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <676e074ffe5f52e6671aac5a2c14e984@case.edu>
Sender: linux-raid-owner@vger.kernel.org
To: John Poirier <john.poirier@case.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It actually is available.
I've tested it and it worked fine for me. But taking a backup is highly 
recommended.
The trick is not to use mdadm, since growing with mdadm is not possible 
at the moment. Use raid-tools instead.
The program raidreconf comes along with raidtools. This prog takes two 
raid-tab files as input which describe the array configuration before 
and after reconfiguration. (See man raidreconf for further details)
I've testet growing an array of 3 disks to 4 disks. Having LVM2 grow its 
volume group along with the raid was another (very tricky) thing...

Greetings,
Frank


John Poirier wrote:

> Greets,
> A lot of RAID 5 hardware controllers can grow a RAID 5 array (online 
> capacity expansion). Will this be available in software RAID?

