From: David Greaves <david@dgreaves.com>
Subject: Re: md Grow for Raid 5
Date: Thu, 10 Mar 2005 12:10:27 +0000
Message-ID: <42303933.8040908@dgreaves.com>
References: <676e074ffe5f52e6671aac5a2c14e984@case.edu>	<422DFE60.5020807@weisshuhn.de>	<422E1C6A.2000006@h3c.com>	<422E31F3.3070104@panix.com>	<422E3352.20002@h3c.com> <16942.15235.437442.433397@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <16942.15235.437442.433397@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Mike Hardy <mhardy@h3c.com>, berk walker <berk@panix.com>, Frank Wittig <fw@weisshuhn.de>, John Poirier <john.poirier@case.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>Growing a raid5 or raid6 by adding another drive is conceptually
>possible to do while the array is online, but I have not definite
>plans to do this (I would like to).  Growing a raid5 into a raid6
>would also be useful.
>These require moving lots of data around, and need to be able to cope
>with drive failure and system crash.... a fun project..
>  
>
EVMS has this already.

It works and is supported (whereas I didn't think raidreconf was).
It would be nice to move the EVMS raid5 extension code into the core md.

FYI, I used EVMS briefly and found it to be an excellent toolset. It's a 
teeny bit rough and a bit OTT for a personal server though so I'm 
sticking with md/lvm2 for now :)

David
