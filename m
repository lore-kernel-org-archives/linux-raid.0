From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 13:54:58 +0800
Message-ID: <4DD9F6B2.4070708@fnarfbargle.com>
References: <4DD50C89.8060006@wildgooses.com>	<20110520020853.GC4759@bitfolk.com>	<4DD61948.8050302@wildgooses.com>	<4DD6409F.9070904@hardwarefreak.com>	<4DD79F4E.7000509@wildgooses.com>	<4DD8D1A7.1090803@hardwarefreak.com>	<4DD8E0D3.1030905@fnarfbargle.com>	<4DD9633E.5000101@hardwarefreak.com>	<4DD99A16.5010108@fnarfbargle.com> <20110523100939.0c019ea2@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110523100939.0c019ea2@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/11 12:09, Roman Mamedov wrote:

> Personally so far I have been sucessful in avoiding the "Advanced Format" crap
> that WD and others are pushing down customers' throats; I have none of such
> drives. It *is* possible to make a non-AF 2TB drive, even a 3-platter one. And
> this one in my opinion the ideal Green drive to buy today, which has the
> advantages of being non-AF and at the same time still in production (maybe
> not for too long, with WD buying Hitachi :-/ ):

I think the term "Advanced Format" crap is a bit harsh.
The reality is that for drives > 2TB it is simply inevitable that bigger 
sectors will be required.

Most sane operating systems use cluster sizes of 4k or larger and have 
done for years, so I really don't see what all the fuss is about.

Peoples inability to properly align the data on their disks can be read 
either as a failing in the technology (the partitioning applications 
have not caught up yet) or simply a lack of understanding on how to 
apply the technology.

Don't blame the drive manufacturers, this should have happened _years_ ago.

