From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Convert raid5 to raid1?
Date: Thu, 10 Mar 2005 18:13:39 -0500
Message-ID: <200503102313.j2ANDi522325@www.watkins-home.com>
References: <4230D279.5090101@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <4230D279.5090101@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Brad Campbell' <brad@wasp.net.au>, 'John McMonagle' <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The only problem I have is related to bad blocks.  This problem is common to
all RAID types.  RAID5 is more likely to have problems.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
Sent: Thursday, March 10, 2005 6:04 PM
To: John McMonagle
Cc: linux-raid@vger.kernel.org
Subject: Re: Convert raid5 to raid1?

John McMonagle wrote:
> Was planning to adding a hot spare to my 3 disk raid5 array and was 
> thinking if I go to 4 drives I would be a  better off  as 2 raid1 arrays 
> considering the current state of raid5.

I just wonder about the comment "considering the current state of raid5".
What might be wrong with 
raid5 currently? I certainly know a number of people (me included) who run
several "large" raid-5 
arrays and don't have any problems.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

