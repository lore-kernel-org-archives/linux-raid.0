From: berk walker <berk@panix.com>
Subject: Re: md Grow for Raid 5
Date: Tue, 08 Mar 2005 18:14:59 -0500
Message-ID: <422E31F3.3070104@panix.com>
References: <676e074ffe5f52e6671aac5a2c14e984@case.edu> <422DFE60.5020807@weisshuhn.de> <422E1C6A.2000006@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <422E1C6A.2000006@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: Frank Wittig <fw@weisshuhn.de>, John Poirier <john.poirier@case.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have you guys seen/tried mdadm 1.90?  I am delightfully experiencing the 
neat issues [read problems] with MY system [sys1], and am too into 
myself to be able to take on serious other-probs.  The doc [which is 
still a tad lite, NB]  has a grow command.  Understand that your files 
exist on/in a filesystem, which has a _size_.  Growing RAID and growing 
fs are two, nonrelated things.  But if you want #2, then you have to do 
both 1 & 2.  There is definately more than one way to "skin a cat", so 
pgms of which you are familiar might be queried first.

Price - 2cents
b-
caveat:
You may not get what you paid for -
    but, you always pay for what you get.    <-Practise .sig

Mike Hardy wrote:

>
> Frank Wittig wrote:
>
>> It actually is available.
>> I've tested it and it worked fine for me. But taking a backup is 
>> highly recommended.
>> The trick is not to use mdadm, since growing with mdadm is not 
>> possible at the moment. Use raid-tools instead.
>> The program raidreconf comes along with raidtools. This prog takes 
>> two raid-tab files as input which describe the array configuration 
>> before and after reconfiguration. (See man raidreconf for further 
>> details)
>
>
> I'll second both major points here:
>
> raidreconf does work, but it can fail and leave things completely 
> destroyed (imagine one bad block somewhere after parity was partially 
> migrated), so take a backup.
>
> Given that you're taking a backup already then, creating a new array 
> (with its optimized resync) might be faster if its an online backup.
>
> I'm 2 for 4 now on raidreconf working, with the two failures (sadly) 
> being of the "operator error" variety - raidreconf is picky and fails 
> slow if your disk sizes aren't what it expects, I found. It got to the 
> end and ran out of space on me due to a slightly different "250GB" 
> disk size once. The other was a bad block along the way - I should 
> have done smartctl -t long on all drives prior to resize. Both lessons 
> learned...
>
> -Mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> .
>

