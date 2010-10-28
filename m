From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Samsung F1 RAID Class SATA/300 1TB drives
Date: Fri, 29 Oct 2010 00:37:44 +0100
Message-ID: <4CCA0948.3060600@anonymous.org.uk>
References: <AANLkTi=CL-EH1HjJ3eTvVL51hT7nF7GA62rxvPqBFGD8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=CL-EH1HjJ3eTvVL51hT7nF7GA62rxvPqBFGD8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/10/2010 00:17, Mark Knecht wrote:
> I saw in Fry's San Jose ad today they were selling these
> Serial-ATA/300 drives for $67. They didn't give a model number but
> scouting around a bit on the web I'm guessing they are a discontinued
> model.
>
> Any inputs on whether these are drives that work well with mdadm RAID?
> Do they support TLER and otherwise work well?
>
> This would just be a home server of some type, nothing industrial.
> Probably a 3 drive RAID-1 or something like that.
>
> Comments?

Well, they're perhaps not great. I bought three and after only about a 
thousand hours one of them was giving SMART errors, then after about 
7,500 hours a second one started doing it too. At that point I replaced 
both with other makes, copying over with ddrescue (or maybe it was 
dd_rescue), which worked without any failed sectors, then ran badblocks 
-w on the Samsungs and the SMART errors went away. The third one of mine 
is still fine, and the other two are now in a ReadyNAS giving good service.

Somebody else on this list recently reported problems with them, though 
that may have been more controller-related than a real problem with the 
drives.

But yes you can set TLER on them (with a custom-built smartmontools from 
SVN or the recently-released 5.40).

Cheers,

John.

