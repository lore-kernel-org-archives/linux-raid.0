From: Mike Hardy <mhardy@h3c.com>
Subject: Re: md Grow for Raid 5
Date: Tue, 08 Mar 2005 13:43:06 -0800
Message-ID: <422E1C6A.2000006@h3c.com>
References: <676e074ffe5f52e6671aac5a2c14e984@case.edu> <422DFE60.5020807@weisshuhn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <422DFE60.5020807@weisshuhn.de>
Sender: linux-raid-owner@vger.kernel.org
To: Frank Wittig <fw@weisshuhn.de>
Cc: John Poirier <john.poirier@case.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Frank Wittig wrote:
> It actually is available.
> I've tested it and it worked fine for me. But taking a backup is highly 
> recommended.
> The trick is not to use mdadm, since growing with mdadm is not possible 
> at the moment. Use raid-tools instead.
> The program raidreconf comes along with raidtools. This prog takes two 
> raid-tab files as input which describe the array configuration before 
> and after reconfiguration. (See man raidreconf for further details)

I'll second both major points here:

raidreconf does work, but it can fail and leave things completely 
destroyed (imagine one bad block somewhere after parity was partially 
migrated), so take a backup.

Given that you're taking a backup already then, creating a new array 
(with its optimized resync) might be faster if its an online backup.

I'm 2 for 4 now on raidreconf working, with the two failures (sadly) 
being of the "operator error" variety - raidreconf is picky and fails 
slow if your disk sizes aren't what it expects, I found. It got to the 
end and ran out of space on me due to a slightly different "250GB" disk 
size once. The other was a bad block along the way - I should have done 
smartctl -t long on all drives prior to resize. Both lessons learned...

-Mike
