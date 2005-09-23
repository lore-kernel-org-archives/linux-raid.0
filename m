From: Orion Poplawski <orion@cora.nwra.com>
Subject: Re: raid5 missing drive at boot question
Date: Fri, 23 Sep 2005 08:51:45 -0600
Message-ID: <43341681.3010604@cora.nwra.com>
References: <dgvb75$hp5$1@sea.gmane.org> <17203.50314.435293.665922@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17203.50314.435293.665922@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday September 22, orion@cora.nwra.com wrote:
> 
>>I created a new 8 disk raid5 set with no spares.  Now, when I boot I end 
>>up with:
>>
>>
>>md3 : active raid5 sdp1[7] sdo1[6] sdn1[5] sdm1[4] sdl1[3] sdk1[2] sdi1[0]
>>       3418687552 blocks level 5, 64k chunk, algorithm 2 [8/7] [U_UUUUUU]
>>
>>which I believe is a "degraded" array.  I then have to do:
>>
>>mdadm -M -a /dev/md3 /dev/sdj1
>>
>>to add in the missing disk.  I had to do this after it was created as well.
>>
>>Why does this happen?  What am I not understanding?
> 
> 
> I suspect that partition sdj1 isn't marked as 0xfd (auto-detect).
> 
> NeilBrown

Right on the money, thanks!


-- 
Orion Poplawski
System Administrator                   303-415-9701 x222
Colorado Research Associates/NWRA      FAX: 303-415-9702
3380 Mitchell Lane, Boulder CO 80301   http://www.co-ra.com
