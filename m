From: Mark Thompson <mark@ruthless.ws>
Subject: Re: problem w/crazy config
Date: Thu, 17 Feb 2005 00:51:40 +1300
Message-ID: <421333CC.6040202@ruthless.ws>
References: <4213250A.1030402@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4213250A.1030402@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: mwaterman@jingmei.org, Mailing List - Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Max Waterman wrote:
> I have 4 200GB drives in a RAID-5 array as masters of each channel, and 
> 4 80GB drives in a RAID-5 array as slaves of each channel.
Hi there,

I had a similar problem and basically it will always happen.  The only 
answer is not to have a raid array running as slaves of each channel as 
it just causes issues.

-- 
Mark
