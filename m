From: Brad Campbell <brad@wasp.net.au>
Subject: Re: 800G RAID5 w/ what FS?
Date: Mon, 05 Apr 2004 21:52:10 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40719CCA.8010709@wasp.net.au>
References: <40719357.8050209@ocis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40719357.8050209@ocis.net>
To: "Jason C. Leach" <jleach@ocis.net>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jason C. Leach wrote:
> hi,
> 
> I was told reiserfs does not work too well with RAID. Is this true? If 
> so I'll go with ext3.  I am using a Promise SX6000 to create a 800G 
> RAID5 array.

I was using ext3 on a 720GB array, and now a 1.4TB array. I have no problems with it besides the 3-4 
hour fsck time when I decide to force a fsck :p)

Regards,
Brad
